import urlMetadata from 'url-metadata'


export const selectionSet = function (__, customAttributes = false) {
    return __.operation.selectionSet.selections[0].selectionSet.selections.map(item => {
        return customAttributes[item.name.value] ? customAttributes[item.name.value] : item.name.value
    })
}

export const selectionSetWithCount = function (__, customAttributes = false) {
    return __.operation.selectionSet.selections[0].selectionSet.selections[0].selectionSet.selections.map(item => {
        return customAttributes[item.name.value] ? customAttributes[item.name.value] : item.name.value
    })
}


export const selectionFields = function (__) {
    return __.fieldNodes[0].selectionSet.selections.reduce((prev, current) => {

        prev[current.name.value] = true
        return prev
    }, {})
}



export const generatePassword = function (length) {
    var result = '';
    var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var charactersLength = characters.length;
    for (var i = 0; i < length; i++) {
        result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }
    return result;
}


export const getUrlMetadata = async function (url) {
    return await urlMetadata(url);
}