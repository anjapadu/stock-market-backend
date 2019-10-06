import {
    GraphQLInt,
    GraphQLInputObjectType
} from 'graphql'

/**
 * Custom input object for paging.
 */
export const DataPage = new GraphQLInputObjectType({
    name: "DataPage",
    description: "Pagination input type to include in the arguments of a query",
    fields: () => ({
        limit: { type: GraphQLInt },
        offset: { type: GraphQLInt }
    })
})

