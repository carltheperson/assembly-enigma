const letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("");
const r1Letters = "BDFHJLCPRTXVZNYEIHGAKMUSQO".split("");
const r1 = r1Letters.map((l) => letters.indexOf(l));

console.log(r1);
