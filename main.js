function simulateCircuit(input) {
  const lines = input.split("\n");
  const initialValues = {};
  const gates = [];
  const wireValues = {};

  for (const line of lines) {
    if (line.includes(":")) {
      const [wire, value] = line.split(":").map((x) => x.trim());
      initialValues[wire] = parseInt(value, 10);
    } else if (line.includes("->")) {
      gates.push(line.trim());
    }
  }

  for (const [wire, value] of Object.entries(initialValues)) {
    wireValues[wire] = value;
  }

  const resolveGate = (gate) => {
    const [expression, output] = gate.split("->").map((x) => x.trim());
    const [input1, op, input2] = expression.split(" ");

    const val1 = isNaN(input1) ? wireValues[input1] : parseInt(input1, 10);
    const val2 = isNaN(input2) ? wireValues[input2] : parseInt(input2, 10);

    if (val1 === undefined || val2 === undefined) return false;

    let result;
    if (op === "AND") result = val1 & val2;
    else if (op === "OR") result = val1 | val2;
    else if (op === "XOR") result = val1 ^ val2;

    wireValues[output] = result;
    return true;
  };

  let unresolvedGates = gates.slice();
  while (unresolvedGates.length > 0) {
    const remainingGates = [];
    for (const gate of unresolvedGates) {
      if (!resolveGate(gate)) {
        remainingGates.push(gate);
      }
    }
    unresolvedGates = remainingGates;
  }

  const zWires = Object.entries(wireValues)
    .filter(([wire]) => wire.startsWith("z"))
    .sort(([a], [b]) => parseInt(a.slice(1)) - parseInt(b.slice(1)));

  const binaryString = zWires
    .map(([, value]) => value)
    .reverse()
    .join("");
  return parseInt(binaryString, 2);
}

const input = ``;

console.log(simulateCircuit(input));
