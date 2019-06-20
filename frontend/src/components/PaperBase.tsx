import * as React from 'react';
import { createMuiTheme, withStyles, WithStyles, createStyles } from '@material-ui/core';
import { ThemeProvider } from '@material-ui/styles';
import CssBaseline from '@material-ui/core/CssBaseline';
import Hidden from '@material-ui/core/Hidden';
import Navigator from './Navigator';
import Content from './Content';
import Header from './Header';

let theme = createMuiTheme({
    typography: {
        fontFamily: [
            'Sarasa Gothic',
            '-apple-system',
            'Arial',
        ].join(','),
        h5: {
            fontWeight: 500,
            fontSize: 26,
            letterSpacing: 0.5,
        },
    },
    palette: {
        primary: {
            light: '#63ccff',
            main: '#9c3300',
            dark: '#006db3',
        },
    },
});

theme = {
    ...theme,
    overrides: {
        MuiDrawer: {
            paper: {
                backgroundColor: '#18202c',
            },
        },
        MuiButton: {
            label: {
                textTransform: 'none',
            },
            contained: {
                boxShadow: 'none',
                '&:active': {
                    boxShadow: 'none',
                },
            },
        },
        MuiTabs: {
            root: {
                marginLeft: theme.spacing(1),
            },
            indicator: {
                height: 3,
                borderTopLeftRadius: 3,
                borderTopRightRadius: 3,
                backgroundColor: theme.palette.common.white,
            },
        },
        MuiTab: {
            root: {
                textTransform: 'none',
                margin: '0 16px',
                minWidth: 0,
                padding: 0,
                [theme.breakpoints.up('md')]: {
                    padding: 0,
                    minWidth: 0,
                },
            },
        },
        MuiIconButton: {
            root: {
                padding: theme.spacing(1),
            },
        },
        MuiTooltip: {
            tooltip: {
                borderRadius: 4,
            },
        },
        MuiDivider: {
            root: {
                backgroundColor: '#404854',
            },
        },
        MuiListItemText: {
            primary: {
                fontWeight: theme.typography.fontWeightMedium,
            },
        },
        MuiListItemIcon: {
            root: {
                color: 'inherit',
                marginRight: 0,
                '& svg': {
                    fontSize: 20,
                },
            },
        },
        MuiAvatar: {
            root: {
                width: 32,
                height: 32,
            },
        },
    },
    props: {
        MuiTab: {
            disableRipple: true,
        },
    },
    mixins: {
        ...theme.mixins,
        toolbar: {
            minHeight: 48,
        },
    },
};

const drawerWidth = 256;

const styles = createStyles({
    root: {
        display: 'flex',
        minHeight: '100vh',
    },
    drawer: {
        [theme.breakpoints.up('sm')]: {
            width: drawerWidth,
            flexShrink: 0,
        },
    },
    appContent: {
        flex: 1,
        display: 'flex',
        flexDirection: 'column',
    },
    mainContent: {
        flex: 1,
        padding: '48px 36px 0',
        background: '#eaeff1',
    },
});

class PaperBase extends React.Component<PaperBaseProps, PaperBaseState> {
    state = {
        mobileOpen: false,
        orderType: 0
    };

    handleDrawerToggle = () => {
        this.setState(state => ({...state, mobileOpen: !state.mobileOpen}));
    };

    handleTabsChange = (_: React.ChangeEvent<{}>, value: number) => {
        this.setState(state => ({...state, orderType: value}))
    };

    render() {
        const {classes} = this.props;

        return (
            <ThemeProvider theme={theme}>
                <div className={classes.root}>
                    <CssBaseline/>
                    <nav className={classes.drawer}>
                        <Hidden smUp implementation="js">
                            <Navigator
                                PaperProps={{style: {width: drawerWidth}}}
                                variant="temporary"
                                open={this.state.mobileOpen}
                                onClose={this.handleDrawerToggle}
                            />
                        </Hidden>
                        <Hidden xsDown implementation="css">
                            <Navigator PaperProps={{style: {width: drawerWidth}}}/>
                        </Hidden>
                    </nav>
                    <div className={classes.appContent}>
                        <Header onDrawerToggle={this.handleDrawerToggle} orderType={this.state.orderType}
                                handleTabsChange={this.handleTabsChange}/>
                        <main className={classes.mainContent}>
                            <Content orderType={this.state.orderType}/>
                        </main>
                    </div>
                </div>
            </ThemeProvider>
        );
    }
}

interface PaperBaseState {
    mobileOpen: boolean;

    /**
     * - 0 for 待支付
     * - 1 for 待发货
     * - 2 for 待收货
     */
    orderType: number;
}

interface PaperBaseProps extends WithStyles<typeof styles> {
}

export default withStyles(styles)(PaperBase);
