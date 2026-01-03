module.exports = {
  $randomEmail,
  $randomString,
  $randomNumber,
};

function $randomEmail() {
  const timestamp = Date.now();
  const random = Math.random().toString(36).substring(7);
  return `user-${timestamp}-${random}@test.com`;
}

function $randomString() {
  const adjectives = ['Happy', 'Healthy', 'Active', 'Strong', 'Wise'];
  const nouns = ['User', 'Patient', 'Member', 'Participant', 'Individual'];
  return `${adjectives[Math.floor(Math.random() * adjectives.length)]} ${nouns[Math.floor(Math.random() * nouns.length)]}`;
}

function $randomNumber(min = 0, max = 100) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}
