REM desativa a exibição dos comandos no prompt do Windows.
@echo off
REM define a variável "file" como o nome do arquivo que contém os endereços IP ou hostnames a serem verificados.
set file=ips.txt
REM loop for que lê cada linha do arquivo "ips.txt" e salva em uma variável temporária "%%a".
for /f "delims=" %%a in (%file%) do (
REM executa um comando de ping para o endereço IP armazenado em "%%a" duas vezes (-n 2), redirecionando a saída para o dispositivo nulo (>nul), para que a saída do ping não seja exibida na tela.
ping -n 2 %%a >nul
REM verifica se o comando "ping" falhou errorlevel 1 se o ping falhou, escreve o endereço IP e a data/hora em um arquivo chamado "offline.log", caso contrário, se o ping foi bem sucedido.
if errorlevel 1 (
echo %%a Offline dia %date% as %time% >> offline.log
) else (
REM  executa o comando "psexec" do PSTools da Sysinternals para enviar um comando de registro para o endereço IP em questão. Este comando adiciona uma chave de registro que exibe o botão "Trocar usuário" na tela de bloqueio.
psexec -n 2 \\%%a -h cmd /c reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v HideFastUserSwitching /t REG_DWORD /d 0 /f
REM verifica se o comando "psexec" falhou (errorlevel 1).  se o "psexec" falhou, escreve o endereço IP e a data/hora em um arquivo chamado "timeout.log".
if errorlevel 1 (
echo %%a PSExec Timeout dia %date% as %time% >> timeout.log
)
)
)
pause
