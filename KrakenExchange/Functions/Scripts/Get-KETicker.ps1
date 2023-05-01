
function Get-KETicker {
<#
.SYNOPSIS
Connects to the Kraken WebSocket API and subscribes to the ticker data for a specified trading pair.

.DESCRIPTION
This function connects to the Kraken WebSocket API and subscribes to the ticker data for a specified trading pair. 
The trading pair is specified as a parameter, with a default value of "BTC/USD".

.PARAMETER Pair
Trading pair.

.EXAMPLE
Get-KETicker

.EXAMPLE
Get-KETicker -Pair "ETH/USD"

.NOTES
The KrakenExchange PowerShell module is not affiliated with or endorsed by Kraken exchange.
Author: wnapierala [at] hotmail.com, chatGPT
Created: 03.2023
#>

    param (
        [string]$Pair = "BTC/USD"
    )
    
    # PS check
    if ($PSVersionTable.PSVersion.Major -lt 7) {
        Write-Host "This script requires PowerShell 7.x or higher to run."
        exit
    }
    
    # Import the necessary namespaces
    Add-Type -AssemblyName System.Net.WebSockets
    Add-Type -AssemblyName System.Threading.Tasks
    
    # Define the URL to connect to
    $krakenUrl = "wss://ws.kraken.com/"
    
    # Define the message to send to the server
    $message = '{"event":"subscribe","pair":["' + $pair + '"],"subscription":{"name":"ticker"}}'
    
    # Create a new client WebSocket object
    $clientWebSocket = [System.Net.WebSockets.ClientWebSocket]::new()
    
    # Connect to the server
    [Void]$clientWebSocket.ConnectAsync($([System.UriBuilder]::new($krakenUrl).Uri), [System.Threading.CancellationToken]::None).Wait()
    
    # Send the message to the server
    [Void]$clientWebSocket.SendAsync([System.ArraySegment[byte]]::new([System.Text.Encoding]::UTF8.GetBytes($message)), [System.Net.WebSockets.WebSocketMessageType]::Text, $true, [System.Threading.CancellationToken]::None).Wait()
    
    # Define a buffer to receive messages
    $receiveBuffer = [System.Array]::CreateInstance([System.Byte], 1024)
    
    # Continuously receive and display messages from the server
    while ($true) {
        $receiveResult = $clientWebSocket.ReceiveAsync([System.ArraySegment[byte]]::new($receiveBuffer), [System.Threading.CancellationToken]::None).Result
        if ($receiveResult.MessageType -eq [System.Net.WebSockets.WebSocketMessageType]::Text) {
            $receivedMessage = [System.Text.Encoding]::UTF8.GetString($receiveBuffer, 0, $receiveResult.Count)
            #$receivedMessage
            [array]$jsonreceivedMessage = ConvertFrom-Json $receivedMessage
            if ($jsonreceivedMessage[1]) {
                $jsonreceivedMessage[1]
            }
        }
    }
}