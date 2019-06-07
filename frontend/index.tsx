import * as React from "react";
import ReactDOM from "react-dom";

class OrderItemData {

}

interface OrderListProps {
}

interface OrderListState {
  totalPages: number,
  curentIndex: number,
  curentPage: OrderItemData[]
}

class OrderList extends React.Component<OrderListProps, OrderListState> {
  state = {
    totalPages: 5,
    curentIndex: 1,
    curentPage: []
  }

  render() {
    return (<div> Hello </div>);
  }
}

ReactDOM.render(<OrderList />, document.getElementById("app"));