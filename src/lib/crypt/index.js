import Cryptr from 'cryptr';
import config from '../../../config'
const { secret } = config;
const cryptr = new Cryptr(secret);

export const decode = (value) => {
    let decriptedValue
    try {
        decriptedValue = cryptr.decrypt(value)
    } catch (e) {
        throw new Error("invalid_token");
    }
    return decriptedValue;
}

export const encode = (value) => {
    return cryptr.encrypt(value);
}