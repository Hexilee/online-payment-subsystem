const Mock = require('mockjs');
const Random = Mock.Random;
const randomInt = (upto) => Math.floor(Math.random() * Math.floor(upto));
const data = {
    totalItem: 200,
    userType: 0,
};
const gen = () => {
    const items = [];
    for (let key of new Array(10).keys()) {
        items.push({
            id: key,
            orderState: 0,
            goodName: Random.csentence(),
            goodDescription: Random.cparagraph(),
            sellerName: Random.cname(),
            buyerName: Random.cname(),
            orderTime: randomInt(1560109154),
            payTime: null,
            deliverTime: null,
            completeTime: null,
            cancelTime: null,
            amount: randomInt(10000)
        });
    }
    return items
};

data.items = gen();
console.log(JSON.stringify({order: data}));

