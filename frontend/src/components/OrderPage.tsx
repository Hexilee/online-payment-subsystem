import * as React from 'react';
import { withStyles, WithStyles, Theme, createStyles, Typography } from '@material-ui/core';
import moment, { Moment } from 'moment';
import CssBaseline from "@material-ui/core/CssBaseline";
import Pagination from 'material-ui-flat-pagination';
import OrderItem, { ItemData } from './OrderItem';

const styles = (theme: Theme) => createStyles({});

class OrderPage extends React.Component<OrderPageProps, OrderPageState> {
    state = {
        offset: 0,
        totalItem: 0,
        userType: 0,
        items: [],
    };

    handlePagination(offset: number) {
        this.setState(state => ({...state, offset: offset}));
    }

    render = () => {
        return (
            <div>
                <Typography>
                    props: {JSON.stringify(this.props)}<br/>
                    state: {JSON.stringify(this.state)}
                </Typography>
                <CssBaseline/>
                <Pagination
                    limit={15}
                    offset={this.state.offset}
                    total={this.state.totalItem}
                    onClick={(e, offset) => this.handlePagination(offset)}
                />
            </div>
        );
    };
}

interface OrderPageProps extends WithStyles<typeof styles> {
    orderType: number;
    endTime: Moment;
    searchWords: string;
}

interface OrderPageState {
    offset: number;
    totalItem: number;
    userType: number;
    items: ItemData[];
}

export default withStyles(styles)(OrderPage);
