# 功能特性

- 将 C-a 作为次要前缀键，同时保留默认的 C-b 前缀键。
- 视觉主题灵感来源于 Powerline。
- 使用 <prefix> + 将任意窗格最大化到新窗口。
- 使用 <prefix> m 切换鼠标模式。
- 状态栏显示笔记本电脑电池状态信息。
- 状态栏显示系统运行时间信息。
- 可选的焦点窗格高亮显示。
- 可配置的新会话、窗口和窗格行为（可选择保留当前路径）。
- 状态栏显示识别 SSH/Mosh 的用户名和主机名信息。
- 识别 SSH/Mosh 的窗格分割（支持自动重连到远程服务器）。
- 复制到操作系统剪贴板（在 Linux 上需要 xsel、xclip 或 wl-copy）。
- 支持 4 位十六进制 Unicode 字符。
- 集成 PathPicker（如果可用）。
- 集成 Urlscan（优先）或 Urlview（如果可用）。

“使用 <prefix> + 将任意窗格最大化到新窗口” 这一功能与内置的 resize-pane -Z 命令不同，因为它允许您进一步分割已最大化的窗格。它也更加灵活：您可以将一个窗格最大化到一个新窗口，然后切换到其他窗口，再返回时，该窗格仍然在其自己的窗口中保持最大化状态。然后，您可以从源窗口或最大化窗口中再次使用 <prefix> + 来最小化窗格。

# 键位绑定

tmux 可以通过一个前缀键组合后跟一个命令键的方式，由已连接的客户端进行控制。此配置使用 C-a 作为次要前缀键，同时保留 C-b 作为默认前缀键。在以下的键位绑定列表中：

 - <prefix> 表示您需要按下 Ctrl + a 或 Ctrl + b
 - <prefix> c 表示您需要先按下 Ctrl + a 或 Ctrl + b，然后按 c
 - <prefix> C-c 表示您需要先按下 Ctrl + a 或 Ctrl + b，然后按 Ctrl + c

此配置使用以下键位绑定：

 - <prefix> e 使用 VISUAL 或 EDITOR 环境变量定义的编辑器（默认为 vim）打开 .local 自定义文件副本。
 - <prefix> r 重新加载配置文件。
 - C-l 清空屏幕和 tmux 历史记录。
 - <prefix> C-c 创建一个新会话。
 - <prefix> C-f 允许您按名称切换到另一个会话。
 - <prefix> C-h 和 <prefix> C-l 让您在不同窗口之间导航（默认的 <prefix> n 未绑定，<prefix> p 被重新赋予功能）。
 - <prefix> Tab 切换到上一个活动的窗口。
 - <prefix> - 垂直分割当前窗格。
 - <prefix> _ 水平分割当前窗格。
 - <prefix> h、<prefix> j、<prefix> k 和 <prefix> l 让您可以像 Vim 一样在窗格之间导航。
 - <prefix> H、<prefix> J、<prefix> K、<prefix> L 让您可以调整窗格大小。
 - <prefix> < 和 <prefix> > 让您可以交换窗格位置。
 - <prefix> + 将当前窗格最大化到一个新窗口中。
 - <prefix> m 切换鼠标模式的开启或关闭。
 - <prefix> U 启动 Urlscan（优先）或 Urlview（如果可用）。
 - <prefix> F 启动 Facebook PathPicker（如果可用）。
 - <prefix> Enter 进入复制模式。
 - <prefix> b 列出粘贴缓冲区。
 - <prefix> p 从顶部粘贴缓冲区粘贴。
 - <prefix> P 让您选择从哪个粘贴缓冲区粘贴。

此外，copy-mode-vi 的键位匹配我自己的 Vim 配置。

copy-mode-vi 的键位绑定：

 - v 开始选择 / 进入可视模式。
 - C-v 在块选择可视模式和可视模式之间切换。
 - H 跳转到行首。
 - L 跳转到行尾。
 - y 将所选内容复制到顶部粘贴缓冲区。
 - Escape 取消当前操作。

您也可以通过在您的 .local 自定义文件副本中将 tmux_conf_preserve_stock_bindings 变量设置为 true 来保留 tmux 自带的默认键位绑定。