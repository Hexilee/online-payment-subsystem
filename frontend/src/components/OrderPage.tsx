import * as React from 'react';
import { withStyles, WithStyles, Theme, createStyles, Typography } from '@material-ui/core';
import RefreshIcon from '@material-ui/icons/Refresh';
import moment, { Moment } from 'moment';

const styles = (theme: Theme) => createStyles({});

const OrderPage: React.FunctionComponent<OrderPageProps> = (props) => {
    const {orderType, endTime, searchWords} = props;
    return (
        <Typography>
            props: {JSON.stringify(props)}
        </Typography>
    );
};

interface OrderPageProps extends WithStyles<typeof styles> {
    orderType: number;
    endTime: Moment;
    searchWords: string;
}

export default withStyles(styles)(OrderPage);
