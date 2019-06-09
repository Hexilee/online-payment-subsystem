import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
import { MouseEventHandler } from 'react';
import * as React from 'react';
import { withStyles, WithStyles, Theme, createStyles, Typography } from '@material-ui/core';
import moment, { Moment } from 'moment';
import CssBaseline from '@material-ui/core/CssBaseline';
import Pagination from 'material-ui-flat-pagination';
import OrderItem, { ItemData } from './OrderItem';
import { Type } from 'serializer.ts/Decorators';
import { BASE_URL } from './config';

const styles = (theme: Theme) => createStyles({});

class OrderPage extends React.Component<OrderPageProps, OrderPageState> {
    state = {
        offset: 0,
        totalItem: 0,
        userType: 0,
        items: [],
        error: {
            display: false,
            title: '',
            content: '',
            handlePositiveAction: () => {
            },
        },
    };

    handleDialogClose() {
        this.setState(state => ({...state, error: {...state.error, display: false}}));
    }

    handlePagination(offset: number) {
        const {orderType, endTime, searchWords} = this.props;
        const url = encodeURI(`${BASE_URL}/order?orderType=${orderType}&endTime=${endTime.valueOf()}&searchWords=${searchWords}&offset=${offset}`);
        fetch(url)
            .then(resp => {
                if (!resp.ok) {
                    throw new Error(`${resp.status}`);
                }
                return resp.json() as Promise<OrderPageData>
            })
            .then(data => {
                this.setState(state => ({error: state.error, offset: offset, ...data}));
            })
            .catch(err => {
                if (err.message === '403') {
                    this.setState(state => ({
                        ...state, error: {
                            display: true,
                            title: '未登陆',
                            content: '请前往登录页面',
                            handlePositiveAction: () => {
                                location.replace('') // TODO: to login page
                            }
                        }
                    }))
                } else {
                    this.setState(state => ({
                        ...state, error: {
                            display: true,
                            title: '未知错误',
                            content: '请检查网络连接或联系系统管理员',
                            handlePositiveAction: () => {
                            }
                        }
                    }))
                }
            });
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
                <Dialog
                    open={this.state.error.display}
                    onClose={this.handleDialogClose}
                    aria-labelledby="alert-dialog-title"
                    aria-describedby="alert-dialog-description"
                >
                    <DialogTitle id="alert-dialog-title">{this.state.error.title}</DialogTitle>
                    <DialogContent>
                        <DialogContentText id="alert-dialog-description">
                            {this.state.error.content}
                        </DialogContentText>
                    </DialogContent>
                    <DialogActions>
                        <Button onClick={this.handleDialogClose} color="primary">
                            关闭
                        </Button>
                        <Button onClick={this.state.error.handlePositiveAction} color="primary" autoFocus>
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
    endTime: Moment;
    searchWords: string;
}

interface OrderPageState {
    offset: number;
    totalItem: number;
    userType: number;
    items: ItemData[];
    error: {
        display: boolean;
        title: string;
        content: string;
        handlePositiveAction: () => void
    };
}

class OrderPageData {
    totalItem: number = 0;
    userType: number = 0;
    @Type(() => ItemData)
    items: ItemData[] = [];
}

export default withStyles(styles)(OrderPage);
