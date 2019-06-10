const Mock = require('mockjs');
const snakeize = require('snakeize');
const Random = Mock.Random;
const randomInt = (upto) => Math.floor(Math.random() * Math.floor(upto));
const gen = () => {
    const items = [];
    for (let key of new Array(1000).keys()) {
        items.push({
            OrderState: randomInt(5),
            GoodName: Random.csentence(),
            GoodDescription: Random.cparagraph(),
            BuyerId: 1,
            SellerId: 1,
            OrderTime: randomInt(1560109154),
            PayTime: null,
            DeliverTime: null,
            SuccessTime: null,
            CancelTime: null,
            Amount: randomInt(10000)
        });
    }
    return items
};

console.log(JSON.stringify(snakeize(gen())));

