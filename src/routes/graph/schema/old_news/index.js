import {
  GraphQLList,
  GraphQLInt,
  GraphQLNonNull,
  GraphQLString
} from 'graphql';
import OldNewTypes from './typeDef';
import models from '@models';

const queries = {},
  mutations = {};


const fetchNews = async () => {
  const data = await models.future_values.findAll({
    where: {
      sent: true,
      has_new: true,
    },
    raw: true,
    order: [['timestamp', 'DESC']]
  })
  return data.map((i) => ({ stockUUID: i.stock_uuid, new: i.new_text }))
}

queries.oldNews = {
  type: GraphQLList(OldNewTypes),
  resolve: fetchNews
}

// queries.users = {
//     type: GraphQLList(UserType),
//     description: 'List all users in the system',
//     resolve: fetchUsers
// }



/*********************/

// mutations.createUser = {
//     type: UserType,
//     description: 'Allows to create a new user',
//     args: {
//         username: {
//             type: GraphQLString,
//             description: 'Email of the user'
//         }
//     },
//     resolve: createUser
// }



export {
  queries,
  mutations
}   