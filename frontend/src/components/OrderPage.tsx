import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
import Divider from '@material-ui/core/Divider';
import Grid from '@material-ui/core/Grid';
import { spacing } from 'material-ui/styles';
import * as React from 'react';
import { withStyles, WithStyles, Theme, createStyles, Typography } from '@material-ui/core';
import moment, { Moment } from 'moment';
import CssBaseline from '@material-ui/core/CssBaseline';
import Pagination from 'material-ui-flat-pagination';
import OrderItem, { ItemData } from './OrderItem';
import { BASE_URL, PAGE_LIMIT } from '../config';

const styles = (theme: Theme) => createStyles({
    root: {
        flexGrow: 1,
    },

    grid: {
        margin: 'auto',
        width: '100%'
    },
    paginator: {
        marginTop: theme.spacing(2),
    }
});

class OrderPage extends React.Component<OrderPageProps, OrderPageState> {
    constructor(props: OrderPageProps) {
        super(props);
        this.state = {
            offset: 0,
            totalItem: 0,
            userType: 0,
            items: [],
            dialogDisplay: false,
            dialog: {
                title: '',
                content: '',
                handleConfirmAction: () => {
                },
            },
        };
        this.handlePagination(0);
    }

    shouldComponentUpdate = (nextProps: Readonly<OrderPageProps>, nextState: Readonly<OrderPageState>, nextContext: any) => {
        if (nextProps !== this.props) {
            this.handlePaginationWithProps(0, nextProps);
        }
        return nextState !== this.state;
    };

    hideDialog = () => {
        this.setState(state => ({...state, dialogDisplay: false}));
    };

    displayDialog = (data: DialogData) => {
        this.setState(state => ({...state, dialogDisplay: true, dialog: data}))
    };

    handlePaginationWithProps = (offset: number, props: Readonly<OrderPageProps>) => {
        const {orderType, searchWords, orderBy} = props;
        const url = encodeURI(`${BASE_URL}/order?orderType=${orderType}&searchWords=${searchWords}&offset=${offset}&limit=${PAGE_LIMIT}&orderBy=${orderBy}`);
        fetch(url, {
            credentials: 'include'
        })
            .then(resp => {
                if (!resp.ok) {
                    throw new Error(`${resp.status}`);
                }
                return resp.json() as Promise<OrderPageData>
            })
            .then(data => {
                this.setState(state => ({...state, offset: offset, ...data}));
            })
            .catch(err => {
                console.log(err);
                if (err.message === '401') {
                    this.displayDialog({
                        title: '未登陆',
                        content: '您还未登录，请前往登录页面',
                        handleConfirmAction: () => {
                            location.replace('') // TODO: to login page
                        }
                    });
                } else {
                    this.displayDialog({
                        title: '未知错误',
                        content: `请检查网络连接或联系系统管理员${err.toString()}`,
                        handleConfirmAction: this.hideDialog
                    });
                }
            });
    };

    handlePagination = (offset: number) => {
        this.handlePaginationWithProps(offset, this.props);
    };

    render = () => {
        const {classes} = this.props;
        return (
            <div className={classes.root}>
                <Grid container spacing={2}>{
                    this.state.items.map(item => (
                        <Grid item key={item.id} className={classes.grid}>
                            <OrderItem item={item} hideDialog={this.hideDialog} displayDialog={this.displayDialog}
                                       userType={this.state.userType} searchWords={this.props.searchWords}
                                       refreshPage={this.props.refreshPage}/>
                        </Grid>
                    ))
                }
                </Grid>
                <Pagination
                    className={classes.paginator}
                    limit={PAGE_LIMIT}
                    offset={this.state.offset}
                    total={this.state.totalItem}
                    onClick={(e, offset) => this.handlePagination(offset)}
                />
                <Dialog
                    open={this.state.dialogDisplay}
                    onClose={this.hideDialog}
                    aria-labelledby="alert-dialog-title"
                    aria-describedby="alert-dialog-description"
                >
                    <DialogTitle id="alert-dialog-title">{this.state.dialog.title}</DialogTitle>
                    <DialogContent>
                        <DialogContentText id="alert-dialog-description">
                            {this.state.dialog.content}
                        </DialogContentText>
                    </DialogContent>
                    <DialogActions>
                        <Button onClick={this.hideDialog} color="primary">
                            关闭
                        </Button>
                        <Button onClick={this.state.dialog.handleConfirmAction} color="primary" autoFocus>
                            确认
                        </Button>
                    </DialogActions>
                </Dialog>
            </div>
        );
    };
}

interface OrderPageProps extends WithStyles<typeof styles> {
    orderType: number;
    searchWords: string;
    orderBy: string;
    refreshPage: () => void;
}

interface OrderPageState {
    offset: number;
    totalItem: number;
    userType: number;
    items: ItemData[];
    dialogDisplay: boolean;
    dialog: DialogData;
}

interface DialogData {
    title: string;
    content: string;
    handleConfirmAction: () => void
}

class OrderPageData {
    totalItem: number = 0;
    userType: number = 0;
    items: ItemData[] = [];
}

export default withStyles(styles)(OrderPage);
