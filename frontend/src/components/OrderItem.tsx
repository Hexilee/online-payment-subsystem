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
    const {classes, item} = props;

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
                <Button color="primary">
                    支付
                </Button>
                <Button color="primary">
                    取消
                </Button>
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
                <CardContent>
                    <Typography paragraph>Method:</Typography>
                    <Typography paragraph>
                        Heat 1/2 cup of the broth in a pot until simmering, add saffron and set aside for 10
                        minutes.
                    </Typography>
                    <Typography paragraph>
                        Heat oil in a (14- to 16-inch) paella pan or a large, deep skillet over medium-high
                        heat. Add chicken, shrimp and chorizo, and cook, stirring occasionally until lightly
                        browned, 6 to 8 minutes. Transfer shrimp to a large plate and set aside, leaving chicken
                        and chorizo in the pan. Add pimentón, bay leaves, garlic, tomatoes, onion, salt and
                        pepper, and cook, stirring often until thickened and fragrant, about 10 minutes. Add
                        saffron broth and remaining 4 1/2 cups chicken broth; bring to a boil.
                    </Typography>
                    <Typography paragraph>
                        Add rice and stir very gently to distribute. Top with artichokes and peppers, and cook
                        without stirring, until most of the liquid is absorbed, 15 to 18 minutes. Reduce heat to
                        medium-low, add reserved shrimp and mussels, tucking them down into the rice, and cook
                        again without stirring, until mussels have opened and rice is just tender, 5 to 7
                        minutes more. (Discard any mussels that don’t open.)
                    </Typography>
                    <Typography>
                        Set aside off of the heat to let rest for 10 minutes, and then serve.
                    </Typography>
                </CardContent>
            </Collapse>
        </Card>
    );
};

interface OrderItemProps extends WithStyles<typeof styles> {
    readonly item: Readonly<ItemData>;
}

export class ItemData {
    id: number = 0;
    orderState: number = 0;
    goodName: string = '';
    goodDescription: string = '';
    sellerName: string = '';
    buyerName: string = '';
    orderTime: number = new Date().getTime() / 1000;
    payTime?: number;
    deliverTime?: number;
    completeTime?: number;
    cancelTime?: number;
    amount: number = 0;
}

export default withStyles(styles)(OrderItem);
