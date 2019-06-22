const Mock = require('mockjs');
const snakeize = require('snakeize');
const Random = Mock.Random;
const randomInt = (upto) => Math.floor(Math.random() * Math.floor(upto));
const gen = () => {
    const items = [];
    for (let key of new Array(1000).keys()) {
        items.push(`
INSERT INTO
  \`Order\` (
    \`BuyerId\`,
    \`SellerId\`,
    \`GoodId\`,
    \`Numbers\`,
    \`OrderState\`,
    \`OrderTime\`,
    \`Amount\`
  )
VALUES
  (
    1,
    1,
    ${randomInt(10)},
    ${randomInt(20)},
    ${randomInt(4)},
    NOW(),
    ${randomInt(10000)}
  );`
        )
    }
    return items
};

console.log(gen().join(`\n`));

