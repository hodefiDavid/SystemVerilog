@ECHO OFF
:: Windows command file to clean up Questa files

if exist work rmdir work /s /q

:: Create dummy file to prevent error
type nul > dummy
del /s /q dummy transcript *.log *stacktrace.* dpiheader.h *.o *~ 1>nul
