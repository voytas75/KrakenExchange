
function Get-KETicker {
    <#
    .SYNOPSIS
    Connects to the Kraken WebSocket API
    .DESCRIPTION
    This code is a PowerShell script that connects to the Kraken WebSocket API and subscribes to the ticker data for a specified trading pair. The user can input the trading pair as a parameter, with a default value of "ETH/USD".

    The script checks if the installed version of PowerShell is version 7.x or higher. If the version is lower than 7, it displays an error message and exits the script.

    The necessary namespaces for WebSocket communication are imported using the Add-Type cmdlet.

    The script defines the URL of the WebSocket server as "wss://ws.kraken.com/" and the message to send to the server as '{"event":"subscribe","pair":["'+$pair+'"],"subscription":{"name":"ticker"}}'. This message subscribes to the ticker data for the specified trading pair.

    A new WebSocket client object is created using the ClientWebSocket class.

    The script connects to the WebSocket server using the ConnectAsync method of the client object.

    The message is sent to the server using the SendAsync method of the client object. The message is encoded using UTF8 encoding and the WebSocketMessageType is set to Text.

    The script defines a buffer to receive messages and continuously receives and displays messages from the server using a while loop. The ReceiveAsync method of the client object is used to receive messages. The received message is decoded using UTF8 encoding and converted from JSON format to a PowerShell object using the ConvertFrom-Json cmdlet. The output of the script is the ticker data for the specified trading pair in JSON format.

    Note that the script includes commented code that displays the received message in its original format and provides information about the structure of the ticker data.
    .PARAMETER Pair
    Trading pair.
    .OUTPUTS
    This output shows the ticker data for the ETH/USD trading pair. The data is returned in a JSON format and includes the following information:
    "a": The ask array, which includes the current best ask price, the whole lot volume, and the lot volume in USD.
    "b": The bid array, which includes the current best bid price, the whole lot volume, and the lot volume in USD.
    "c": The last trade closed array, which includes the price and lot volume of the last trade closed.
    "v": The volume array, which includes the volume in the last 24 hours and the volume weighted average price in the last 24 hours.
    "p": The price array, which includes the volume weighted average price in the last 24 hours and the volume weighted average price in the last 30 days.
    "t": The trade array, which includes the number of trades in the last 24 hours and the number of trades in the last 30 days.
    "l": The low array, which includes the lowest price in the last 24 hours and the lowest price in the last 30 days.
    "h": The high array, which includes the highest price in the last 24 hours and the highest price in the last 30 days.
    "o": The open array, which includes the opening price in the last 24 hours and the opening price in the last 30 days.
    The output also includes the channel ID, channel name, event type, and trading pair for the ticker data.
    .EXAMPLE
    .\krakenticker.ps1 -Pair
    .\krakenticker.ps1 -Pair "ETH/USD"
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