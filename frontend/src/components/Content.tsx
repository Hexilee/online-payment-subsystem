import { ChangeEvent } from 'react';
import * as React from 'react';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import Paper from '@material-ui/core/Paper';
import Grid from '@material-ui/core/Grid';
import TextField from '@material-ui/core/TextField';
import { withStyles, WithStyles, Theme, createStyles } from '@material-ui/core';
import SearchIcon from '@material-ui/icons/Search';
import RefreshIcon from '@material-ui/icons/Refresh';
import moment, { Moment } from 'moment';
import OrderPage from './OrderPage';

const styles = (theme: Theme) => createStyles({
    paper: {
        width: '80%',
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
    addUser: {
        marginRight: theme.spacing(1),
    },
    contentWrapper: {
        margin: '40px 16px',
    },
    textField: {
        marginLeft: theme.spacing(1),
        marginRight: theme.spacing(1),
        width: 400,
    },
    gridItem: {
        marginTop: 10
    }
});

const Content: React.FunctionComponent<ContentProps> = (props) => {
    const {classes, orderType} = props;
    const [selectedDate, setSelectedDate] = React.useState<Moment>(moment());
    const [searchWords, setSearchWords] = React.useState<string>('');

    const handleDateChange = (event: ChangeEvent<HTMLInputElement>) => {
        setSelectedDate(moment(event.target.value, 'YYYY/MM/DD, HH:MM'));
    };

    const handleSearchWords = (event: ChangeEvent<HTMLInputElement>) => {
        setSearchWords(event.target.value);
    };

    return (
        <Paper className={classes.paper}>
            <AppBar className={classes.searchBar} position="static" color="default" elevation={0}>
                <Toolbar>
                    <Grid container spacing={2} alignItems="center">
                        <Grid item className={classes.gridItem}>
                            <SearchIcon className={classes.block} color="inherit"/>
                        </Grid>
                        <Grid item xs className={classes.gridItem}>
                            <TextField
                                onChange={handleSearchWords}
                                fullWidth
                                placeholder="搜索商品名或商品描述..."
                                className={classes.textField}
                                InputProps={{
                                    disableUnderline: true,
                                    className: classes.searchInput,
                                }}
                            />
                        </Grid>
                        <Grid item className={classes.gridItem}>
                            <TextField
                                id="datetime-local"
                                label="截至"
                                type="datetime-local"
                                defaultValue={moment().format('YYYY-MM-DDTHH:MM')}
                                className={classes.textField}
                                InputLabelProps={{
                                    shrink: true,
                                }}
                                onChange={handleDateChange}
                            />
                        </Grid>
                    </Grid>
                </Toolbar>
            </AppBar>
            <div className={classes.contentWrapper}>
                <OrderPage orderType={orderType} endTime={selectedDate} searchWords={searchWords}/>
            </div>
        </Paper>
    );
};

interface ContentProps extends WithStyles<typeof styles> {
    orderType: number
}

export default withStyles(styles)(Content);
