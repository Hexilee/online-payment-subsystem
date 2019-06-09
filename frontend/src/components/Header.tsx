import * as React from 'react';
import AppBar from '@material-ui/core/AppBar';
import Avatar from '@material-ui/core/Avatar';
import Button from '@material-ui/core/Button';
import Grid from '@material-ui/core/Grid';
import HelpIcon from '@material-ui/icons/Help';
import Hidden from '@material-ui/core/Hidden';
import IconButton from '@material-ui/core/IconButton';
import MenuIcon from '@material-ui/icons/Menu';
import NotificationsIcon from '@material-ui/icons/Notifications';
import Tab from '@material-ui/core/Tab';
import Tabs from '@material-ui/core/Tabs';
import Toolbar from '@material-ui/core/Toolbar';
import Tooltip from '@material-ui/core/Tooltip';
import Typography from '@material-ui/core/Typography';
import { withStyles, Theme, WithStyles, createStyles } from '@material-ui/core';
// @ts-ignore
import avatar from '../../assets/image/avatar.jpg'

const lightColor = 'rgba(255, 255, 255, 0.7)';

const styles = (theme: Theme) => createStyles({
    secondaryBar: {
        zIndex: 0,
    },
    menuButton: {
        marginLeft: -theme.spacing(1),
    },
    iconButtonAvatar: {
        padding: 4,
    },
    link: {
        textDecoration: 'none',
        color: lightColor,
        '&:hover': {
            color: theme.palette.common.white,
        },
    },
    avatar: {},
    button: {
        borderColor: lightColor,
    },
});

const Header: React.FunctionComponent<HeaderProps> = props => {
    const {classes, onDrawerToggle, orderType, handleTabsChange} = props;
    return (
        <React.Fragment>
            <AppBar color="primary" position="sticky" elevation={0}>
                <Toolbar>
                    <Grid container spacing={1} alignItems="center">
                        <Hidden smUp>
                            <Grid item>
                                <IconButton
                                    color="inherit"
                                    aria-label="打开工具栏"
                                    onClick={onDrawerToggle}
                                    className={classes.menuButton}
                                >
                                    <MenuIcon/>
                                </IconButton>
                            </Grid>
                        </Hidden>
                        <Grid item xs/>
                        <Grid item>
                            <Tooltip title="通知 • 暂无">
                                <IconButton color="inherit">
                                    <NotificationsIcon/>
                                </IconButton>
                            </Tooltip>
                        </Grid>
                        <Grid item>
                            <IconButton color="inherit" className={classes.iconButtonAvatar}>
                                <Avatar
                                    className={classes.avatar}
                                    src={avatar}
                                    alt="我的头像"
                                />
                            </IconButton>
                        </Grid>
                    </Grid>
                </Toolbar>
            </AppBar>
            <AppBar
                component="div"
                className={classes.secondaryBar}
                color="primary"
                position="static"
                elevation={0}
            >
                <Toolbar>
                    <Grid container alignItems="center" spacing={1}>
                        <Grid item xs>
                            <Typography color="inherit" variant="h5" component="h1">
                                我的订单
                            </Typography>
                        </Grid>
                        <Grid item>
                            <Button className={classes.button} variant="outlined" color="inherit" size="small">
                                联系客服
                            </Button>
                        </Grid>
                        <Grid item>
                            <Tooltip title="帮助">
                                <IconButton color="inherit">
                                    <HelpIcon/>
                                </IconButton>
                            </Tooltip>
                        </Grid>
                    </Grid>
                </Toolbar>
            </AppBar>
            <AppBar
                component="div"
                className={classes.secondaryBar}
                color="primary"
                position="static"
                elevation={0}
            >
                <Tabs value={orderType} textColor="inherit" onChange={handleTabsChange}>
                    <Tab textColor="inherit" label="待付款"/>
                    <Tab textColor="inherit" label="待发货"/>
                    <Tab textColor="inherit" label="待收货"/>
                    <Tab textColor="inherit" label="已完成"/>
                    <Tab textColor="inherit" label="已取消"/>
                </Tabs>
            </AppBar>
        </React.Fragment>
    );
};

interface HeaderProps extends WithStyles<typeof styles> {
    onDrawerToggle: React.MouseEventHandler<HTMLButtonElement>;
    orderType: number;
    handleTabsChange: (event: React.ChangeEvent<{}>, orderType: number) => void;
}

export default withStyles(styles)(Header);
