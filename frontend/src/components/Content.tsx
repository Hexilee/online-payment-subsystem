import FormHelperText from '@material-ui/core/FormHelperText';
import IconButton from '@material-ui/core/IconButton';
import MenuItem from '@material-ui/core/MenuItem';
import Select from '@material-ui/core/Select';
import Tooltip from '@material-ui/core/Tooltip';
import { ChangeEvent } from 'react';
import * as React from 'react';
import AppBar from '@material-ui/core/AppBar';
import FormControl from '@material-ui/core/FormControl';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import Paper from '@material-ui/core/Paper';
import Grid from '@material-ui/core/Grid';
import TextField from '@material-ui/core/TextField';
import { withStyles, WithStyles, Theme, createStyles } from '@material-ui/core';
import SearchIcon from '@material-ui/icons/Search';
import RefreshIcon from '@material-ui/icons/Refresh';
import OrderPage from './OrderPage';
import Button from '@material-ui/core/Button';

const styles = (theme: Theme) => createStyles({
    paper: {
        maxWidth: 1200,
        margin: 'auto',
        overflow: 'hidden',
    },
    searchBar: {
        borderBottom: '1px solid rgba(0, 0, 0, 0.12)',
    },
    searchInput: {
        fontSize: theme.typography.fontSize,
    },
    block: {
        display: 'block',
    },
    search: {
        marginRight: theme.spacing(1),
    },
    contentWrapper: {
        margin: '40px 16px',
    },
    formControl: {
        margin: theme.spacing(1),
        minWidth: 150,
    },
    gridItem: {
        marginTop: theme.spacing(1),
    },
});

const Content: React.FunctionComponent<ContentProps> = (props) => {
    const {classes, orderType} = props;
    const [orderBy, setOrderBy] = React.useState<string>('order_time');
    let words = '';
    const [searchWords, setSearchWords] = React.useState<string>(words);
    const [, refresh] = React.useState({});
    return (
        <Paper className={classes.paper}>
            <AppBar className={classes.searchBar} position="static" color="default" elevation={0}>
                <Toolbar>
                    <Grid container spacing={3} alignItems="center">
                        <Grid item className={classes.gridItem}>
                            <SearchIcon className={classes.block} color="inherit"/>
                        </Grid>
                        <Grid item xs className={classes.gridItem}>
                            <TextField
                                onChange={(event) => {
                                    words = event.target.value
                                }}
                                fullWidth
                                placeholder="搜索商品名或商品描述..."
                                InputProps={{
                                    disableUnderline: true,
                                    className: classes.searchInput,
                                }}
                            />
                        </Grid>
                        <Grid item className={classes.gridItem}>
                            <Button variant="outlined" color="primary" className={classes.search} onClick={() => {
                                setSearchWords(words)
                            }}>
                                搜索
                            </Button>
                        </Grid>
                        <Grid item className={classes.gridItem}>
                            <FormControl className={classes.formControl}>
                                <Select
                                    value={orderBy}
                                    onChange={(event) => {
                                        setOrderBy(event.target.value as string)
                                    }}
                                    displayEmpty
                                    name="orderBy"
                                >
                                    <MenuItem value={'order_time'}>按预订时间排序</MenuItem>
                                    <MenuItem value={'pay_time'}>按支付时间排序</MenuItem>
                                    <MenuItem value={'deliver_time'}>按发货时间排序</MenuItem>
                                    <MenuItem value={'success_time'}>按收货时间排序</MenuItem>
                                    <MenuItem value={'cancel_time'}>按取消时间排序</MenuItem>
                                </Select>
                            </FormControl>
                            <Tooltip title="刷新">
                                <IconButton onClick={() => refresh({})}>
                                    <RefreshIcon className={classes.block} color="inherit"/>
                                </IconButton>
                            </Tooltip>
                        </Grid>
                    </Grid>
                </Toolbar>
            </AppBar>
            <div className={classes.contentWrapper}>
                <OrderPage orderType={orderType} searchWords={searchWords} orderBy={orderBy} refreshPage={() => refresh({})}/>
            </div>
        </Paper>
    );
};

interface ContentProps extends WithStyles<typeof styles> {
    orderType: number
}

export default withStyles(styles)(Content);
