import models from '@models';
import { generatePassword } from '../../../../lib/utils';
// var bcrypt = require('bcrypt');
import moment from 'moment';
import { encode } from '../../../../lib/crypt';
const saltRounds = 10;



export async function fetchStocks(_parent, data, _, __) {
    try {
        return await models.stocks.findAll({

        });
    } catch (e) {
        console.log(e);
    }
}

export async function fetchStock({ stock_uuid }, data, _, __) {
    try {
        return await models.stocks.findOne({
            where: {
                uuid: stock_uuid
            }
        })
    } catch (e) {
        console.log(e);
    }
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