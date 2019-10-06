import models from '@models';

export async function fetchStockPrice({ uuid } = {}, { stock_uuid } = {}, _, __) {

    console.log({ uuid }, { stock_uuid })

    return await models.stock_price.findAll({
        where: {
            stock_uuid: uuid || stock_uuid
        }
    });
}

export async function fetchStockPriceById({ stock_price_uuid } = {}, { uuid }) {
    return await models.stock_price.findOne({
        where: {
            uuid: stock_price_uuid || uuid
        }
    })
}

export async function fetchLastPrice({ uuid } = {}, { stock_uuid }, _, __) {
    return await models.stock_price.findOne({
        where: {
            stock_uuid: uuid,
        },
        order: [['timestamp', 'DESC']]
    })
}

// export async function createUser(_parent, data, _, __) {
//     const { username } = data;
//     const count = await models.users.count({
//         where: {
//             username
//         },
//         raw: true
//     })
//     if (count > 0) {
//         throw new Error('USER_EXISTS')
//     }
//     try {
//         let newGeneratedPassword = generatePassword(8);
//         console.log({ newGeneratedPassword });
//         const password = await bcrypt.hash(newGeneratedPassword, saltRounds);
//         const insertQuery = await models.users.create({
//             username,
//             password,
//             name: username
//         }, {
//                 isNewRecord: true,
//                 raw: true
//             });
//         let response = insertQuery.get({ plain: true });
//         response["token"] = 'Bearer ' + encode(JSON.stringify({
//             id: response.idUser,
//             isAdmin: response.isAdmin,
//             expiration: null,
//             createdAt: moment().unix()
//         }));
//         return response;
//     } catch (e) {
//         console.log('Error createUser', e)
//     }

// }


// export async function logInUser(_parent, data, _, __) {

//     const { username, password } = data;
//     const response = await models.users.findOne({
//         where: {
//             username
//         },
//         raw: true
//     })
//     if (!response)
//         throw new Error("USER_NOT_EXIST")
//     const result = await bcrypt.compare(password, response.password);
//     if (result == true) {
//         response["token"] = 'Bearer ' + encode(JSON.stringify({
//             id: response.idUser,
//             isAdmin: response.isAdmin,
//             expiration: null,
//             createdAt: moment().unix()
//         }));
//         return response;
//     } else {
//         throw new Error("WRONG_PASS")
//     }
// }