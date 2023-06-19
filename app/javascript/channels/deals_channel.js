import consumer from "channels/consumer"

consumer.subscriptions.create("DealsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(data)
    document.getElementById('quantity-' + data.deal_id).innerHTML = `<strong>Total Available: </strong> ${data.qty}`
    // Called when there's incoming data on the websocket for this channel
  }
});
