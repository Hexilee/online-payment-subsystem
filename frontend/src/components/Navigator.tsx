import * as React from 'react';
import clsx from 'clsx';
import { withStyles, WithStyles, Theme, createStyles, Link } from '@material-ui/core';
import Divider from '@material-ui/core/Divider';
import Drawer, { DrawerProps } from '@material-ui/core/Drawer';
import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import ListItemIcon from '@material-ui/core/ListItemIcon';
import ListItemText from '@material-ui/core/ListItemText';
import HomeIcon from '@material-ui/icons/Home';
import PeopleIcon from '@material-ui/icons/People';
import DnsRoundedIcon from '@material-ui/icons/DnsRounded';
import PublicIcon from '@material-ui/icons/Public';
import SettingsEthernetIcon from '@material-ui/icons/SettingsEthernet';
import TimerIcon from '@material-ui/icons/Timer';
import SettingsIcon from '@material-ui/icons/Settings';
import PhonelinkSetupIcon from '@material-ui/icons/PhonelinkSetup';
import * as config from '../config';

const categories = [
    {
        id: '控制台',
        children: [
            { id: '账号管理', icon: <PeopleIcon />, href: config.USER_SETTING_URL },
            { id: '我的订单', icon: <DnsRoundedIcon />, active: true, href: '#' },
            { id: '在线预订', icon: <PublicIcon />, href: config.ONLINE_ORDER_URL },
            { id: '对账与审核', icon: <SettingsEthernetIcon />, href: config.ORDER_INSPECT_URL },
        ],
    },
    {
        id: '系统',
        children: [
            { id: '系统设置', icon: <SettingsIcon /> },
            { id: '通知管理', icon: <TimerIcon /> },
            { id: '关于', icon: <PhonelinkSetupIcon /> },
        ],
    },
];

const styles = (theme: Theme) => createStyles({
    categoryHeader: {
        paddingTop: theme.spacing(2),
        paddingBottom: theme.spacing(2),
    },
    categoryHeaderPrimary: {
        color: theme.palette.common.white,
    },
    item: {
        paddingTop: 5,
        paddingBottom: 5,
        color: 'rgba(255, 255, 255, 0.7)',
        '&:hover,&:focus': {
            backgroundColor: 'rgba(255, 255, 255, 0.08)',
        },
    },
    itemCategory: {
        backgroundColor: '#232f3e',
        boxShadow: '0 -1px 0 #404854 inset',
        paddingTop: theme.spacing(2),
        paddingBottom: theme.spacing(2),
    },
    firebase: {
        fontSize: 24,
        color: theme.palette.common.white,
    },
    itemActiveItem: {
        color: '#b03c08',
    },
    itemPrimary: {
        fontSize: 'inherit',
    },
    itemIcon: {
        minWidth: 'auto',
        marginRight: theme.spacing(2),
    },
    divider: {
        marginTop: theme.spacing(2),
    },
});

const Navigator: React.FunctionComponent<NavigatorProps> = (props) => {
    const { classes, ...other } = props;
    return (
        <Drawer variant="permanent" {...other}>
            <List disablePadding>
                <ListItem className={clsx(classes.firebase, classes.item, classes.itemCategory)}>
                    在线支付系统
                </ListItem>
                <Link href={config.HOME_URL} target='_blank' underline='none'>
                    <ListItem className={clsx(classes.item, classes.itemCategory)}>
                        <ListItemIcon className={classes.itemIcon}>
                            <HomeIcon />
                        </ListItemIcon>
                        <ListItemText
                            classes={{
                                primary: classes.itemPrimary,
                            }}
                        >
                            主页
                    </ListItemText>
                    </ListItem>
                </Link>
                {categories.map(({ id, children }) => (
                    <React.Fragment key={id}>
                        <ListItem className={classes.categoryHeader}>
                            <ListItemText
                                classes={{
                                    primary: classes.categoryHeaderPrimary,
                                }}
                            >
                                {id}
                            </ListItemText>
                        </ListItem>
                        {children.map(({ id: childId, icon, active, href }) => (
                            <Link href={href} target='_blank' underline='none'>
                                <ListItem
                                    key={childId}
                                    button
                                    className={clsx(classes.item, active && classes.itemActiveItem)}
                                >
                                    <ListItemIcon className={classes.itemIcon}>{icon}</ListItemIcon>
                                    <ListItemText
                                        classes={{
                                            primary: classes.itemPrimary,
                                        }}
                                    >
                                        {childId}
                                    </ListItemText>
                                </ListItem>
                            </Link>
                        ))}
                        <Divider className={classes.divider} />
                    </React.Fragment>
                ))}
            </List>
        </Drawer>
    );
};


interface NavigatorProps extends WithStyles<typeof styles>, Omit<DrawerProps, 'classes'> {
}

export default withStyles(styles)(Navigator);
