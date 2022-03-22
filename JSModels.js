/*
dont use location piker
dont start in location piker task until you tell foula
dont refactor location name
*/

class CustomLocation {
  constructor({ longitude, latitude, address, name }) {
    this.longitude = longitude;
    this.latitude = latitude;
    this.address = address;
    this.name = name;
  }
}

class UserType {
  constructor({
    id,
    name,
    avatar,
    birthDay,
    createdDate,
    email,
    phoneNumber,
    password,
    loc,
    address,
  }) {
    this.name = name;
    this.id = id;
    this.avatar = avatar;
    this.birthDay = birthDay;
    this.createdDate = createdDate;
    this.email = email;
    this.password = password;
    this.phoneNumber = phoneNumber;
    this.address = address;
    this.loc = loc;

    if (!this.isUserValid()) {
      throw new Error("User specific data is invalid!");
    }
  }

  isUserValid() {
    return (
      this.emailValidate(this.email) &&
      this.nameValidate(this.name) &&
      this.passValidate(this.password)
    );
  }

  //Validation

  emailValidate(email) {
    //sergisamirbpoule@gmial
    return new RegExp(
      "^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:.[a-zA-Z0-9-]+)*$"
    ).test(email);
  }

  nameValidate(name) {
    return new RegExp(
      //Sergi Rizkallah
      "^([a-zA-Z]{2,}[\r\n\t\f\v ][a-zA-Z]{1,}'?-?[a-zA-Z]{2,}[\r\n\t\f\v ]?([a-zA-Z]{1,})?)"
    ).test(name);
  }

  passValidate(password) {
    return new RegExp(
      //SergiSamir3&
      "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[@$!%*?&])[A-Za-z0-9@$!%*?&]{8,}$"
    ).test(password);
  }
}

class Client extends UserType {
  constructor({
    id,
    name,
    avatar,
    birthDay,
    createdDate,
    email,
    phoneNumber,
    password,
    loc,
    address,
    subscription,
  }) {
    super({
      id,
      name,
      avatar,
      birthDay,
      createdDate,
      email,
      phoneNumber,
      password,
      loc,
      address,
    });
    this.subscription = subscription;

    if (!this.isClientValid()) {
      throw new Error("Client specific data is invalid!");
    }
  }

  isClientValid() {
    return this.subscriptionValidate(this.subscription);
  }

  // Validation
  subscriptionValidate(subscription) {
    return subscription > 0;
  }
}

class Mechanic extends UserType {
  constructor({
    name,
    email,
    id,
    birthDay,
    createdDate,
    userState,
    sex,
    type,
    avatar,
    loc,
    phoneNumber,
    isAccepted,
    isCenter,
    nationalID,
    password,
  }) {
    super({
      name,
      email,
      id,
      birthDay,
      createdDate,
      userState,
      sex,
      type,
      avatar,
      loc,
      phoneNumber,
      password,
    });

    this.isAccepted = isAccepted;
    this.isCenter = isCenter;
    this.nationalID = nationalID;

    if (!this.isMechValid()) {
      throw new Error("Mechanic specific data is invalid!");
    }
  }

  isMechValid() {
    return this.nationalIDValidate(this.nationalID);
  }

  // Validation
  nationalIDValidate(id) {
    return !(id == undefined);
  }
}

class TowProvider extends UserType {
  constructor({
    name,
    email,
    id,
    birthDay,
    createdDate,
    userState,
    sex,
    type,
    avatar,
    loc,
    phoneNumber,
    isAccepted,
    isCenter,
    nationalID,
    password,
    address,
  }) {
    super({
      name,
      email,
      id,
      birthDay,
      createdDate,
      userState,
      sex,
      type,
      avatar,
      loc,
      phoneNumber,
      password,
      address,
    });

    this.towDrivers = [];
    this.isAccepted = isAccepted;
    this.isCenter = isCenter;
    this.nationalID = nationalID;

    if (!this.isTowProviderValid()) {
      throw new Error("Tow Provider specific data is invalid!");
    }
  }

  isTowProviderValid() {
    return this.nationalIDValidate(this.nationalID);
  }

  // Validation
  nationalIDValidate(id) {
    return !(id == undefined);
  }
}

class TowDriver {
  TowDriver({ nationalID, isAccepted, name, hireDate }) {
    this.nationalID = nationalID;
    this.isCenter = isCenter;
    this.isAccepted = isAccepted;
    this.name = name;
    this.hireDate = hireDate;
  }
}

class Car {
  constructor({ id, model, color, noPlate, noChassis }) {
    this.id = id;
    this.model = model;
    this.color = color;
    this.noPlate = noPlate;
    this.noChassis = noChassis;
  }
}

class WorkShop {
  WorkShop({ id, name, isCenter, phoneNumber, loc }) {
    this.id = id;
    this.name = name;
    this.isCenter = isCenter;
    this.phoneNumber = phoneNumber;
    this.loc = loc;
  }
}
