import models from '@models';
import { generatePassword } from '../../../../lib/utils';
// var bcrypt = require('bcrypt');
import moment from 'moment';
import { encode } from '../../../../lib/crypt';
const saltRounds = 10;



export async function fetchUsers(_parent, data, _, __) {
    try {
        return await models.users.findAll({

        });
    } catch (e) {
        console.log(e);
    }
}

export async function getParams() {
    return {
        comission: global.comission,
        exchangeRate: global.exchangeRate,
        status: global.status
    }
}

export async function findUser({ user_uuid } = {}, { uuid }, _, __) {
    try {

        if (uuid === '') {
            console.log('LLEGO VACIO')
            return {
                uuid: null,
                username: null,
                admin: false,
                balance: null,
            }
        }

        return await models.users.findOne({
            where: {
                uuid: user_uuid || uuid
            }
        })
    } catch (e) {
        console.log(e)
        return {
            uuid: null,
            username: null,
            admin: false,
            balance: null,
        }
    }
}

export async function logInUser(_parent, { username, password }, _, __) {

    const userResponse = await models.users.findOne({
        where: {
            username: {
                [models.Sequelize.Op.iLike]: username
            }
        },
        raw: true
    })
    if (!userResponse) {
        throw new Error('NOT_FOUND')
    }
    if (userResponse['password'] !== password) {
        throw new Error('WRONG_PASS')
    }
    return userResponse
}

export async function destroyUser(_, { uuid }) {
    await models.transactions.destroy({
        where: {
            user_uuid: uuid
        }
    })

    await models.holdings.destroy({
        where: {
            user_uuid: uuid
        }
    })
    
    await models.users.destroy({
        where: {
            uuid
        }
    })
    return true
}

export async function createUser(_parent, data, _, __) {
    const { username, password } = data;
    const count = await models.users.count({
        where: {
            username: {
                [models.Sequelize.Op.iLike]: username
            }
        },
        raw: true
    })
    if (count > 0) {
        throw new Error('USER_EXISTS')
    }
    try {

        const insertQuery = await models.users.create({
            username,
            password,
        }, {
            isNewRecord: true,
            raw: true
        });
        return insertQuery.get({ plain: true });
    } catch (e) {
        console.log('Error createUser', e)
    }

}


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