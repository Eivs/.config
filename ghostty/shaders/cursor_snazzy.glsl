// sRGB -> Linear 转换。Ghostty 传入 sRGB 值，但管线在 linear 空间运行，不做转换颜色会偏暗。
vec3 sRGBToLinear(vec3 c) {
    return mix(c / 12.92, pow((c + 0.055) / 1.055, vec3(2.4)), step(vec3(0.04045), c));
}

// ---- 可调参数 ----------------------------------------------------------------
vec4 TRAIL_COLOR = vec4(sRGBToLinear(iCurrentCursorColor.rgb), iCurrentCursorColor.a);
const float DURATION = 0.5;              // 动画总时长（秒）
const float TRAIL_SIZE = 1;            // smear 强度：0=四角同步, 1=前导角瞬间到位（最大拖尾）
const float THRESHOLD_MIN_DISTANCE = 0.0; // 光标移动超过此距离才画拖尾（单位：光标高度）
const float BLUR = 2.0;                  // 抗锯齿模糊像素数
const float TRAIL_THICKNESS = 1.0;       // 拖尾厚度：1=全高, 0=无
const float TRAIL_THICKNESS_X = 0.9;     // 拖尾水平厚度缩放

const float FADE_ENABLED = 1.0;          // 1=拖尾沿移动方向渐变淡出, 0=均匀色
const float FADE_EXPONENT = 0.5;         // fade 渐变指数，越大尾部越暗


// ---- easing 常量 ------------------------------------------------------------
const float PI = 3.14159265359;
const float C1_BACK = 1.70158;
const float C2_BACK = C1_BACK * 1.525;
const float C3_BACK = C1_BACK + 1.0;
const float C4_ELASTIC = (2.0 * PI) / 3.0;
const float C5_ELASTIC = (2.0 * PI) / 4.5;
const float SPRING_STIFFNESS = 9.0;
const float SPRING_DAMPING = 0.9;

// ---- easing 函数（选一） ----------------------------------------------------
// float ease(float x) { return x; }                                          // Linear
// float ease(float x) { return 1.0 - (1.0 - x) * (1.0 - x); }              // EaseOutQuad
// float ease(float x) { return 1.0 - pow(1.0 - x, 3.0); }                  // EaseOutCubic
// float ease(float x) { return 1.0 - pow(1.0 - x, 4.0); }                  // EaseOutQuart
// float ease(float x) { return 1.0 - pow(1.0 - x, 5.0); }                  // EaseOutQuint
// float ease(float x) { return sin((x * PI) / 2.0); }                      // EaseOutSine
// float ease(float x) { return x == 1.0 ? 1.0 : 1.0 - pow(2.0, -10.0 * x); } // EaseOutExpo

// EaseOutCirc — 开始快结束慢，适合拖尾回弹
// float ease(float x) {
//     return sqrt(1.0 - pow(x - 1.0, 2.0));
// }

// // EaseOutBack
// float ease(float x) {
//     return 1.0 + C3_BACK * pow(x - 1.0, 3.0) + C1_BACK * pow(x - 1.0, 2.0);
// }

// // EaseOutElastic
// float ease(float x) {
//     return x == 0.0 ? 0.0
//          : x == 1.0 ? 1.0
//                     : pow(2.0, -10.0 * x) * sin((x * 10.0 - 0.75) * C4_ELASTIC) + 1.0;
// }

// // Parametric Spring — 带震荡的弹簧衰减
float ease(float x) {
    x = clamp(x, 0.0, 1.0);
    float decay = exp(-SPRING_DAMPING * SPRING_STIFFNESS * x);
    float freq = sqrt(SPRING_STIFFNESS * (1.0 - SPRING_DAMPING * SPRING_DAMPING));
    float osc = cos(freq * 6.283185 * x) + (SPRING_DAMPING * sqrt(SPRING_STIFFNESS) / freq) * sin(freq * 6.283185 * x);
    return 1.0 - decay * osc;
}

// 矩形 SDF：p=采样点, xy=中心, b=半宽半高
float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b)
{
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// 线段 SDF（Inigo Quilez），s 为 inout 累乘正负号判断点在多边形内
// 全部用 step 替代 if，避免 GPU 分支
float seg(in vec2 p, in vec2 a, in vec2 b, inout float s, float d) {
    vec2 e = b - a;
    vec2 w = p - a;
    vec2 proj = a + e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
    float segd = dot(p - proj, p - proj);
    d = min(d, segd);

    float c0 = step(0.0, p.y - a.y);
    float c1 = 1.0 - step(0.0, p.y - b.y);
    float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
    float allCond = c0 * c1 * c2;
    float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
    float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
    s *= flip;
    return d;
}

// 凸四边形 SDF：依次对四条边调用 seg
float getSdfConvexQuad(in vec2 p, in vec2 v1, in vec2 v2, in vec2 v3, in vec2 v4) {
    float s = 1.0;
    float d = dot(p - v1, p - v1);

    d = seg(p, v1, v2, s, d);
    d = seg(p, v2, v3, s, d);
    d = seg(p, v3, v4, s, d);
    d = seg(p, v4, v1, s, d);

    return s * sqrt(d);
}

// 归一化坐标到 NDC [-1, 1]，以屏幕高度为基准保持宽高比
vec2 normalize(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

// 基于距离的抗锯齿
float antialising(float distance, float blurAmount) {
  return 1. - smoothstep(0., normalize(vec2(blurAmount, blurAmount), 0.).x, distance);
}

// 根据角与移动方向的 dot 值分配动画时长
// dot ∈ [-2,2]：>0.5=前导角, ∈[-0.5,0.5]=侧边角, <-0.5=拖尾角
float getDurationFromDot(float dot_val, float DURATION_LEAD, float DURATION_SIDE, float DURATION_TRAIL) {
    float isLead = step(0.5, dot_val);
    float isSide = step(-0.5, dot_val) * (1.0 - isLead);
    float duration = mix(DURATION_TRAIL, DURATION_SIDE, isSide);
    duration = mix(duration, DURATION_LEAD, isLead);
    return duration;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord){
    #if !defined(WEB)
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    #endif

    // 归一化到 NDC [-1, 1]
    vec2 vu = normalize(fragCoord, 1.);
    vec2 offsetFactor = vec2(-.5, 0.5);

    vec4 currentCursor = vec4(normalize(iCurrentCursor.xy, 1.), normalize(iCurrentCursor.zw, 0.));
    vec4 previousCursor = vec4(normalize(iPreviousCursor.xy, 1.), normalize(iPreviousCursor.zw, 0.));

    // 光标矩形中心和半宽半高
    vec2 centerCC = currentCursor.xy - (currentCursor.zw * offsetFactor);
    vec2 halfSizeCC = currentCursor.zw * 0.5;
    vec2 centerCP = previousCursor.xy - (previousCursor.zw * offsetFactor);
    vec2 halfSizeCP = previousCursor.zw * 0.5;

    // 当前光标 SDF，用于拖尾上挖洞显示真实光标
    float sdfCurrentCursor = getSdfRectangle(vu, centerCC, halfSizeCC);

    float lineLength = distance(centerCC, centerCP);
    float minDist = currentCursor.w * THRESHOLD_MIN_DISTANCE;

    vec4 newColor = vec4(fragColor);

    float baseProgress = iTime - iTimeCursorChange;

    // 只有移动距离 > 阈值且动画未结束才画拖尾
    if (lineLength > minDist && baseProgress < DURATION - 0.001) {

        // === 计算当前光标四个角（受 TRAIL_THICKNESS 缩放） ===

        // Y (Height) with TRAIL_THICKNESS
        float cc_half_height = currentCursor.w * 0.5;
        float cc_center_y = currentCursor.y - cc_half_height;
        float cc_new_half_height = cc_half_height * TRAIL_THICKNESS;
        float cc_new_top_y = cc_center_y + cc_new_half_height;
        float cc_new_bottom_y = cc_center_y - cc_new_half_height;

        // X (Width) with TRAIL_THICKNESS
        float cc_half_width = currentCursor.z * 0.5;
        float cc_center_x = currentCursor.x + cc_half_width;
        float cc_new_half_width = cc_half_width * TRAIL_THICKNESS_X;
        float cc_new_left_x = cc_center_x - cc_new_half_width;
        float cc_new_right_x = cc_center_x + cc_new_half_width;

        vec2 cc_tl = vec2(cc_new_left_x, cc_new_top_y);
        vec2 cc_tr = vec2(cc_new_right_x, cc_new_top_y);
        vec2 cc_bl = vec2(cc_new_left_x, cc_new_bottom_y);
        vec2 cc_br = vec2(cc_new_right_x, cc_new_bottom_y);

        // === 计算上一个光标四个角 ===
        float cp_half_height = previousCursor.w * 0.5;
        float cp_center_y = previousCursor.y - cp_half_height;
        float cp_new_half_height = cp_half_height * TRAIL_THICKNESS;
        float cp_new_top_y = cp_center_y + cp_new_half_height;
        float cp_new_bottom_y = cp_center_y - cp_new_half_height;

        float cp_half_width = previousCursor.z * 0.5;
        float cp_center_x = previousCursor.x + cp_half_width;
        float cp_new_half_width = cp_half_width * TRAIL_THICKNESS_X;
        float cp_new_left_x = cp_center_x - cp_new_half_width;
        float cp_new_right_x = cp_center_x + cp_new_half_width;

        vec2 cp_tl = vec2(cp_new_left_x, cp_new_top_y);
        vec2 cp_tr = vec2(cp_new_right_x, cp_new_top_y);
        vec2 cp_bl = vec2(cp_new_left_x, cp_new_bottom_y);
        vec2 cp_br = vec2(cp_new_right_x, cp_new_bottom_y);

        // === 每角动画时长：前导/侧边/拖尾 ===
        const float DURATION_TRAIL = DURATION;
        const float DURATION_LEAD = DURATION * (1.0 - TRAIL_SIZE); // TRAIL_SIZE 越大 lead 越快到位
        const float DURATION_SIDE = (DURATION_LEAD + DURATION_TRAIL) / 2.0;

        vec2 moveVec = centerCC - centerCP;
        vec2 s = sign(moveVec);

        // 每角单位方向向量与移动方向做 dot，决定角是前导/侧边/拖尾
        float dot_tl = dot(vec2(-1., 1.), s);
        float dot_tr = dot(vec2( 1., 1.), s);
        float dot_bl = dot(vec2(-1.,-1.), s);
        float dot_br = dot(vec2( 1.,-1.), s);

        // assign durations based on dot products
        float dur_tl = getDurationFromDot(dot_tl, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL);
        float dur_tr = getDurationFromDot(dot_tr, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL);
        float dur_bl = getDurationFromDot(dot_bl, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL);
        float dur_br = getDurationFromDot(dot_br, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL);

        // 水平移动时整条竖直边应同步，避免拖尾扭曲
        float isMovingRight = step(0.5, s.x);
        float isMovingLeft  = step(0.5, -s.x);
        float dot_right_edge = (dot_tr + dot_br) * 0.5;
        float dur_right_rail = getDurationFromDot(dot_right_edge, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL);

        float dot_left_edge = (dot_tl + dot_bl) * 0.5;
        float dur_left_rail = getDurationFromDot(dot_left_edge, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL);

        float final_dur_tl = mix(dur_tl, dur_left_rail, isMovingLeft);
        float final_dur_bl = mix(dur_bl, dur_left_rail, isMovingLeft);

        float final_dur_tr = mix(dur_tr, dur_right_rail, isMovingRight);
        float final_dur_br = mix(dur_br, dur_right_rail, isMovingRight);

        // 每角从 cp 位置到 cc 位置做 eased 插值
        float prog_tl = ease(clamp(baseProgress / final_dur_tl, 0.0, 1.0));
        float prog_tr = ease(clamp(baseProgress / final_dur_tr, 0.0, 1.0));
        float prog_bl = ease(clamp(baseProgress / final_dur_bl, 0.0, 1.0));
        float prog_br = ease(clamp(baseProgress / final_dur_br, 0.0, 1.0));

        // 当前拖尾四边形的四个顶点（旧位置→新位置 按进度插值）
        vec2 v_tl = mix(cp_tl, cc_tl, prog_tl);
        vec2 v_tr = mix(cp_tr, cc_tr, prog_tr);
        vec2 v_br = mix(cp_br, cc_br, prog_br);
        vec2 v_bl = mix(cp_bl, cc_bl, prog_bl);

        // === 绘制拖尾凸四边形 ===
        float sdfTrail = getSdfConvexQuad(vu, v_tl, v_tr, v_br, v_bl);

        // 沿移动方向的渐变：0=尾部, 1=头部
        vec2 fragVec = vu - centerCP;
        float fadeProgress = clamp(dot(fragVec, moveVec) / (dot(moveVec, moveVec) + 1e-6), 0.0, 1.0);

        vec4 trail = TRAIL_COLOR;

        // 纯水平/垂直移动时不抗锯齿，避免光标尾部脉冲闪烁
        float effectiveBlur = BLUR;
        if (BLUR < 2.5) {
          float isDiagonal = abs(s.x) * abs(s.y); // 1=斜向, 0=水平/垂直
          float effectiveBlur = mix(0.0, BLUR, isDiagonal);
        }
        float shapeAlpha = antialising(sdfTrail, effectiveBlur);

        // fade：拖尾越靠近尾部越透明
        if (FADE_ENABLED > 0.5) {
            float easedProgress = pow(fadeProgress, FADE_EXPONENT);
            trail.a *= easedProgress;
        }

        float finalAlpha = trail.a * shapeAlpha;
        newColor = mix(newColor, vec4(trail.rgb, newColor.a), finalAlpha);

        // 在拖尾上挖洞，露出真实光标字符
        newColor = mix(newColor, fragColor, step(sdfCurrentCursor, 0.));
    }

    fragColor = newColor;
}