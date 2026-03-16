class EventEmitterMock {
  addListener() {
    return {
      remove() {},
    };
  }

  removeAllListeners() {}
}

module.exports = new EventEmitterMock();

