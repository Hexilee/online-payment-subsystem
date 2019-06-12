import { blue, cyan, green, grey, yellow } from '@material-ui/core/colors';
import Tooltip from '@material-ui/core/Tooltip';
import { black } from 'material-ui/styles/colors';
import * as React from 'react';
import { withStyles, WithStyles, Theme, createStyles, makeStyles } from '@material-ui/core';
import clsx from 'clsx';
import Card from '@material-ui/core/Card';
import CardHeader from '@material-ui/core/CardHeader';
import CardMedia from '@material-ui/core/CardMedia';
import CardContent from '@material-ui/core/CardContent';
import CardActions from '@material-ui/core/CardActions';
import Collapse from '@material-ui/core/Collapse';
import Avatar from '@material-ui/core/Avatar';
import IconButton from '@material-ui/core/IconButton';
import Typography from '@material-ui/core/Typography';
import red from '@material-ui/core/colors/red';
import FavoriteIcon from '@material-ui/icons/Favorite';
import ShareIcon from '@material-ui/icons/Share';
import Icon from '@material-ui/icons/'
import ExpandMoreIcon from '@material-ui/icons/ExpandMore';
import MoreVertIcon from '@material-ui/icons/MoreVert';
import moment from 'moment';
import Button from '@material-ui/core/Button';
import Divider from '@material-ui/core/Divider';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import { BASE_URL } from '../config';

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
    const {classes, item, userType, displayDialog, hideDialog} = props;
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
                handleConfirmAction: hideDialog,
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
                    handleConfirmAction: hideDialog
                });
            }
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
                handleConfirmAction: hideDialog,
            })
        }).catch(err => {
            console.log(err);
            if (err.message === '409') {
                displayDialog({
                    title: '卖家或卖家账户已注销',
                    content: '请联系管理员退款',
                    handleConfirmAction: hideDialog,
                });
            } else {
                displayDialog({
                    title: '未知错误',
                    content: `请检查网络连接或联系系统管理员${err.toString()}`,
                    handleConfirmAction: hideDialog
                });
            }
        });
    };
    const positiveButton = () => {
        if (userType === 1 && item.orderState == 0) {
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
    };
    const negativeButton = () => {
        if (userType === 1 && item.orderState == 0) {
            return (<Button color="primary" onClick={() => {
                displayDialog({
                    title: '您确定要取消吗？',
                    content: '该订单当前未支付，可随意取消',
                    handleConfirmAction: cancel,
                })
            }}>
                取消订单
            </Button>)
        }
    };

    return (
        <Card>
            <CardHeader
                avatar={
                    <Avatar aria-label="Recipe" className={classes.avatar}>
                        {item.goodName[0]}
                    </Avatar>
                }
                title={item.goodName}
                subheader={`下单时间：${moment(item.orderTime * 1000).format('YYYY/MM/DD HH:MM:SS')}`}
            />
            <CardContent>
                <Typography variant="body2" color="textSecondary" component="p">
                    {item.goodDescription}
                </Typography>
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
    hideDialog: () => void;
    displayDialog: (data: DialogData) => void;
}

export class ItemData {
    id: number = 0;
    orderState: number = 0;
    goodName: string = '';
    goodDescription: string = '';
    sellerName: string = '';
    buyerName: string = '';
    orderTime: number = new Date().getTime() / 1000;
    payTime: number | null = null;
    deliverTime: number | null = null;
    completeTime: number | null = null;
    cancelTime: number | null = null;
    amount: number = 0;
}

const additionalAttr = {
    id: '订单号',
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
                return moment(time * 1000).format('YYYY/MM/DD HH:MM:SS');
            }
            // fallthrough
        }
        case 'id':
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
