const Mock = require('mockjs');
const Random = Mock.Random;
const data = Mock.mock({
    totalItem: 200,
    userType: 0,
    'items|10': [{
        // 属性 id 是一个自增数，起始值为 1，每次增 1
        'id|+1': 1,
        orderState: 0,
        goodName: Random.csentence(),
        goodDescription: Random.cparagraph(),
        sellerName: Random.cname(),
        buyerName: Random.cname(),
        'orderTime|0-1560109154': 0,
        payTime: null,
        deliverTime: null,
        completeTime: null,
        cancelTime: null,
        'amount|50-1000': 0
    }]
});
console.log(JSON.stringify({order: data}));
