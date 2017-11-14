function Write-HostWithColor ($msg) {
    Write-Host $msg -ForegroundColor Red -BackgroundColor Yellow
}

function Show-OrderXml ($xmlFile) {
    $xmlContent = [xml] $(Get-Content $xmlFile)

    $purchaseOrder = $xmlContent.purchaseOrder
    Write-HostWithColor "purchaseOrder"
    $purchaseOrder
    
    $shipTo = $purchaseOrder.shipTo
    Write-HostWithColor "shipTo"
    $shipTo

    $billTo = $purchaseOrder.billTo
    Write-HostWithColor "billTo"
    $billTo

    $comment = $purchaseOrder.comment
    Write-HostWithColor "comment"
    $comment

    $items = $purchaseOrder.items.ChildNodes
    $itemsCount = $items.Count
    Write-HostWithColor $itemsCount
    $currentItemCount = 0
    $items | % {
        $item = $_
        $currentItemCount++
        Write-HostWithColor "\nPurchase Order Item [$currentItemCount]"
        $item.partNum
        $item.productName
        $item.quantity
        $item.USPrice
        $item.shipDate
        $item.comment
    }
}

Show-OrderXml -xmlFile "C:\Github\PowerShell\Utilities\XmlParser\comp.xml"


