onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /top/top_if/clock
add wave -noupdate -divider Stream-In
add wave -noupdate -format Literal -expand /top/top_if/valid
add wave -noupdate -format Literal -expand /top/top_if/busy
add wave -noupdate -format Literal -expand /top/top_if/stream
add wave -noupdate -divider Stream-Out
add wave -noupdate -format Literal -expand /top/top_if/valido
add wave -noupdate -format Literal -expand /top/top_if/streamo
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7746 ns} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 39
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {1426 ns} {10938 ns}
