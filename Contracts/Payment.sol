contract Payment {
  address public seller;
  uint public price;
  bool public paid;
  bool public refunded;
  mapping(address => uint) public refunds;

  event PaymentReceived(address indexed _from, uint _value);
  event RefundIssued(address indexed _to, uint _value);

  constructor(address _seller, uint _price) public {
    require(_seller != address(0), "Seller address cannot be zero.");
    require(_price > 0, "Price must be greater than zero.");
    seller = _seller;
    price = _price;
    paid = false;
    refunded = false;
  }

  function pay() public payable {
    require(msg.sender != address(0), "Sender address cannot be zero.");
    require(msg.value == price, "Incorrect payment amount.");
    require(!paid, "Payment has already been made.");
    require(!refunded, "Payment has been refunded.");
    seller.transfer(msg.value);
    paid = true;
    emit PaymentReceived(msg.sender, msg.value);
  }

  function requestRefund() public {
    require(msg.sender == seller, "Only the seller can issue a refund.");
    require(paid, "Payment has not been made.");
    require(!refunded, "Payment has already been refunded.");
    refunds[msg.sender] = address(this).balance;
    refunded = true;
    emit RefundIssued(msg.sender, refunds[msg.sender]);
  }

  function withdrawRefund() public {
    require(refunds[msg.sender] > 0, "No refund available for the sender address.");
    uint refundAmount = refunds[msg.sender];
    refunds[msg.sender] = 0;
    msg.sender.transfer(refundAmount);
  }
}
