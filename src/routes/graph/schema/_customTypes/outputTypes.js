import {
    GraphQLObjectType,
    GraphQLInt,
    GraphQLList,
    GraphQLString,
    GraphQLBoolean
} from 'graphql';
import JSONType from 'graphql-type-json'

/**
 * Response object that adds total count of rows
 */
export const findCountType = (type) => new GraphQLObjectType({
    name: `findCount_${type}`,
    description: 'Allows to encapsulate another type to transform it in an object capable of give the data in an array and it\'s size in the count field. Will create another level for the selection sets.',
    fields: () => ({
        data: {
            type: GraphQLList(type),
            description: 'Array of values'
        },
        count: {
            type: GraphQLInt,
            description: 'Size of total values found'
        }
    })
})


export const updateResponseType = new GraphQLObjectType({
    name: 'updateResponse',
    description: 'Basic response type for updates where we just need to know that happened successfuly',
    fields: function () {
        return {
            updated: {
                type: GraphQLBoolean,
                description: 'If updated successfuly or not'
            },
            message: {
                type: GraphQLString,
                description: 'Custom message to show'
            }
        }
    }
})

export const SuccessType = new GraphQLObjectType({
    name: 'successType',
    description: 'Basic response type where just we need to know that the query or proceess finished successfuly',
    fields: function () {
        return {
            success: {
                type: GraphQLBoolean,
                description: 'If succeded or not'
            },
            message: {
                type: GraphQLString,
                description: 'Custom message to show'
            },
            response: {
                type: JSONType
            }
        }
    }
})