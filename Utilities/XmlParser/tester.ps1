
function Show-OrderXml ($xmlFile) {
    $xmlContent = [xml] $(Get-Content $xmlFile)

    $purchaseOrder = $xmlContent.purchaseOrder
    "purchaseOrder"
    $purchaseOrder
    
    $shipTo = $purchaseOrder.shipTo
    "shipTo"
    $shipTo

    $billTo = $purchaseOrder.billTo
    $billTo

    $comment = $purchaseOrder.comment
    "comment"
    $comment

    $items = $purchaseOrder.items.ChildNodes
    $items | % {
        $item = $_
        $item.partNum
        $item.productName
        $item.quantity
        $item.USPrice
        $item.shipDate
        $item.comment
    }

    

}

Show-OrderXml -xmlFile "C:\temp\comp.xml"


