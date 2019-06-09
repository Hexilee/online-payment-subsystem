import { ChangeEvent } from 'react';
import * as React from 'react';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import Paper from '@material-ui/core/Paper';
import Grid from '@material-ui/core/Grid';
import TextField from '@material-ui/core/TextField';
import { withStyles, WithStyles, Theme, createStyles } from '@material-ui/core';
import SearchIcon from '@material-ui/icons/Search';
import RefreshIcon from '@material-ui/icons/Refresh';
import moment, { Moment } from 'moment';
import OrderPage from './OrderPage';

const styles = (theme: Theme) => createStyles({});

const OrderItem: React.FunctionComponent<OrderItemProps> = (props) => {
    return (
        <div></div>
    );
};

interface OrderItemProps extends WithStyles<typeof styles> {
    items: ItemData[]
}

export class ItemData {
    id: number = 0;
    orderState: number = 0;
    goodName: string = "";
    goodDescription: string = "";
    sellerName: string = "";
    buyerName: string = "";
    orderTime: Date = new Date();
    payTime?: Date;
    deliverTime?: Date;
    completeTime?: Date;
    cancelTime?: Date;
    amount: number = 0;
}

export default withStyles(styles)(OrderItem);
