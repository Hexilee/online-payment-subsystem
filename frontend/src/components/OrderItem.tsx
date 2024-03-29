import { blue, cyan, green, grey, yellow } from '@material-ui/core/colors';
import { red400 } from 'material-ui/styles/colors';
import * as React from 'react';
import { withStyles, WithStyles, Theme, createStyles, makeStyles } from '@material-ui/core';
import clsx from 'clsx';
import Card from '@material-ui/core/Card';
import CardHeader from '@material-ui/core/CardHeader';
import CardContent from '@material-ui/core/CardContent';
import CardActions from '@material-ui/core/CardActions';
import Collapse from '@material-ui/core/Collapse';
import Avatar from '@material-ui/core/Avatar';
import IconButton from '@material-ui/core/IconButton';
import Typography from '@material-ui/core/Typography';
import red from '@material-ui/core/colors/red';
import ExpandMoreIcon from '@material-ui/icons/ExpandMore';
import moment from 'moment';
import Button from '@material-ui/core/Button';
import Divider from '@material-ui/core/Divider';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import { BASE_URL } from '../config';
import reactStringReplace from 'react-string-replace';

const styles = (theme: Theme) =>
    createStyles({
            expand: {
                transform: 'rotate(0deg)',
                marginLeft: 'auto',
                transition: theme.transitions.create('transform', {
                    duration: theme.transitions.duration.shortest,
                }),
            },
            expandOpen: {
                transform: 'rotate(180deg)',
            },
            avatar: {
                backgroundColor: randomColor(),
            },
            price: {
                fontSize: theme.spacing(3),
                color: red[500]
            },
        },
    );

const colors = [red, blue, green, yellow, cyan, grey];
const randomInt = (upto: number) => Math.floor(Math.random() * Math.floor(upto));
const randomColor = () => colors[randomInt(colors.length)][500];
const OrderItem: React.FunctionComponent<OrderItemProps> = (props) => {
    const [expanded, setExpanded] = React.useState(false);
    const handleExpandClick = () => {
        setExpanded(!expanded);
    };
    const {classes, item, userType, displayDialog, hideDialog, searchWords, refreshPage} = props;
    const pay = () => {
        const targetURL = encodeURI(`${BASE_URL}/order/${item.id}?targetState=1`);
        fetch(targetURL, {
            method: 'PUT',
            credentials: 'include',
        }).then(resp => {
            if (!resp.ok) {
                throw new Error(`${resp.status}`);
            }
            displayDialog({
                title: '付款成功！',
                content: `您已支付￥${item.amount}`,
                handleConfirmAction: () => {
                    hideDialog();
                    refreshPage();
                },
            })
        }).catch(err => {
            console.log(err);
            if (err.message === '402') {
                displayDialog({
                    title: '余额不足',
                    content: '您的账户余额不足，请前去充值',
                    handleConfirmAction: () => {
                        location.replace('') // TODO: to top up
                    }
                });
            } else if (err.message === '409') {
                displayDialog({
                    title: '卖家账户已注销',
                    content: '请取消订单',
                    handleConfirmAction: cancel
                });
            } else {
                displayDialog({
                    title: '未知错误',
                    content: `请检查网络连接或联系系统管理员${err.toString()}`,
                    handleConfirmAction: () => {
                        hideDialog();
                        refreshPage();
                    }
                });
            }
        });
    };

    const deliver = () => {
        const targetURL = encodeURI(`${BASE_URL}/order/${item.id}?targetState=2`);
        fetch(targetURL, {
            method: 'PUT',
            credentials: 'include',
        }).then(resp => {
            if (!resp.ok) {
                throw new Error(`${resp.status}`);
            }
            displayDialog({
                title: '已确认发货',
                content: `请耐心等待商品送达`,
                handleConfirmAction: () => {
                    hideDialog();
                    refreshPage();
                },
            })
        }).catch(err => {
            console.log(err);
            displayDialog({
                title: '未知错误',
                content: `请检查网络连接或联系系统管理员${err.toString()}`,
                handleConfirmAction: () => {
                    hideDialog();
                    refreshPage();
                }
            });
        });
    };

    const receive = () => {
        const targetURL = encodeURI(`${BASE_URL}/order/${item.id}?targetState=3`);
        fetch(targetURL, {
            method: 'PUT',
            credentials: 'include',
        }).then(resp => {
            if (!resp.ok) {
                throw new Error(`${resp.status}`);
            }
            displayDialog({
                title: '已确认收货',
                content: `希望您购物愉快`,
                handleConfirmAction: () => {
                    hideDialog();
                    refreshPage();
                },
            })
        }).catch(err => {
            console.log(err);
            displayDialog({
                title: '未知错误',
                content: `请检查网络连接或联系系统管理员${err.toString()}`,
                handleConfirmAction: () => {
                    hideDialog();
                    refreshPage();
                }
            });
        });
    };

    const cancel = () => {
        const targetURL = encodeURI(`${BASE_URL}/order/${item.id}?targetState=4`);
        fetch(targetURL, {
            method: 'PUT',
            credentials: 'include',
        }).then(resp => {
            if (!resp.ok) {
                throw new Error(`${resp.status}`);
            }
            displayDialog({
                title: '订单已取消',
                content: `若此订单已支付，支付金额￥${item.amount}将会退还到买家的账户余额中`,
                handleConfirmAction: () => {
                    hideDialog();
                    refreshPage();
                },
            })
        }).catch(err => {
            console.log(err);
            if (err.message === '409') {
                displayDialog({
                    title: '卖家或卖家账户已注销',
                    content: '请联系管理员退款',
                    handleConfirmAction: () => {
                        hideDialog();
                        refreshPage();
                    },
                });
            } else {
                displayDialog({
                    title: '未知错误',
                    content: `请检查网络连接或联系系统管理员${err.toString()}`,
                    handleConfirmAction: () => {
                        hideDialog();
                        refreshPage();
                    },
                });
            }
        });
    };
    const positiveButton = () => {
        if (userType === 1 && item.orderState === 0) {
            return (<Button color="primary" onClick={() => {
                displayDialog({
                    title: '您确定要付款吗？',
                    content: `您需要支付￥${item.amount}`,
                    handleConfirmAction: pay,
                })
            }}>
                付款
            </Button>)
        }

        if (userType === 0 && item.orderState === 1) {
            return (<Button color="primary" onClick={() => {
                displayDialog({
                    title: '您确定已发货吗？',
                    content: `买家将看到商品状态变化`,
                    handleConfirmAction: deliver,
                })
            }}>
                确认发货
            </Button>)
        }

        if (userType === 1 && item.orderState === 2) {
            return (<Button color="primary" onClick={() => {
                displayDialog({
                    title: '您确定已收货吗？',
                    content: `一经确认，该订单将被视为已完成`,
                    handleConfirmAction: receive,
                })
            }}>
                确认收货
            </Button>)
        }
        return;
    };
    const negativeButton = () => {
        if (item.orderState === 0) {
            return (<Button color="primary" onClick={() => {
                displayDialog({
                    title: '您确定要取消吗？',
                    content: '该订单当前未支付，可随意取消',
                    handleConfirmAction: cancel,
                })
            }}>
                取消订单
            </Button>)
        } else if (item.orderState === 1 || item.orderState === 2 || item.orderState === 3) {
            return (<Button color="primary" onClick={() => {
                displayDialog({
                    title: '您确定要退款吗？',
                    content: `请双方事先沟通好；支付金额￥${item.amount}将会退还到买家的账户余额中`,
                    handleConfirmAction: cancel,
                })
            }}>
                退款
            </Button>)
        }
        return;
    };

    const highlightSearchWords = (str: string) =>
        searchWords === '' ? str : reactStringReplace(str, searchWords, (words, i) => (
            <span key={i} style={{
                color: red[600],
                fontWeight: 'bold',
            }}>{words}</span>));

    return (
        <Card>
            <CardHeader
                avatar={
                    <Avatar aria-label="Recipe" className={classes.avatar}>
                        {item.goodName[0]}
                    </Avatar>
                }
                title={<Typography>{highlightSearchWords(item.goodName)}</Typography>}
                subheader={`下单时间：${moment(item.orderTime * 1000).format('YYYY/MM/DD HH:mm:ss')}`}
            />
            <CardContent>
            </CardContent>
            <CardActions disableSpacing>
                {positiveButton()}
                {negativeButton()}
                <Typography className={classes.price}>
                    ￥{item.amount}
                </Typography>
                <IconButton
                    className={clsx(classes.expand, {
                        [classes.expandOpen]: expanded,
                    })}
                    onClick={handleExpandClick}
                    aria-expanded={expanded}
                    aria-label="Show more"
                >
                    <ExpandMoreIcon/>
                </IconButton>
            </CardActions>
            <Collapse in={expanded} timeout="auto" unmountOnExit>
                <Divider variant="middle"/>
                <CardContent>
                    <Table>
                        <TableBody>
                            {
                                Object.entries(additionalAttr).map(entry => {
                                        const [attr, tableKey] = entry;
                                        return (
                                            <TableRow key={attr}>
                                                <TableCell component="th" scope="row">
                                                    {tableKey}
                                                </TableCell>
                                                <TableCell align="right">{displayAttr(item, attr)}</TableCell>
                                            </TableRow>
                                        )
                                    }
                                )
                            }
                        </TableBody>
                    </Table>
                </CardContent>
            </Collapse>
        </Card>
    );
};

interface DialogData {
    title: string;
    content: string;
    handleConfirmAction: () => void
}

interface OrderItemProps extends WithStyles<typeof styles> {
    userType: number;
    item: ItemData;
    searchWords: string;
    refreshPage: () => void;
    hideDialog: () => void;
    displayDialog: (data: DialogData) => void;
}

export class ItemData {
    id: number = 0;
    orderState: number = 0;
    goodName: string = '';
    sellerName: string = '';
    buyerName: string = '';
    goodId: number = 0;
    numbers: number = 0;
    orderTime: number = new Date().getTime() / 1000;
    payTime: number | null = null;
    deliverTime: number | null = null;
    completeTime: number | null = null;
    cancelTime: number | null = null;
    amount: number = 0;
}

const additionalAttr = {
    id: '订单号',
    goodId: '商品号',
    numbers: '商品数量',
    orderState: '订单状态',
    sellerName: '卖家',
    buyerName: '买家',
    payTime: '付款时间',
    deliverTime: '发货时间',
    completeTime: '确认到货时间',
    cancelTime: '订单取消时间',
};

const displayAttr = (item: ItemData, attr: string): string => {
    switch (attr) {
        case 'orderState': {
            switch (item.orderState) {
                case 0:
                    return '待付款';
                case 1:
                    return '待发货';
                case 2:
                    return '待收货';
                case 3:
                    return '已完成';
                case 4:
                    return '已取消';
                default:
                    return '未知';
            }
        }
        case 'payTime':
        case 'deliverTime':
        case 'completeTime':
        case 'cancelTime': {
            const time = item[attr];
            if (time !== null) {
                return moment(time * 1000).format('YYYY/MM/DD HH:mm:ss');
            }
            // fallthrough
        }
        case 'id':
        case 'goodId':
        case 'numbers':
        case 'sellerName':
        case 'buyerName':
            try {
                const value = item[attr];
                if (value !== null) {
                    return value.toString();
                }
            } catch (e) {
                // fallthrough
            }
        default:
            return '暂无记录'
    }
};

export default withStyles(styles)(OrderItem);
