import { promises as fs } from "fs";
import path from "path";
import _ from "lodash";
import faker from "faker";

async function main() {
  let checkPositions = [];
  let checkPositionItems = [];

  for (const i of _.range(0, 20)) {
    for (const direction of ["L", "R"]) {
      let _id: string = `FB ${i}${direction}`;
      checkPositions.push({
        _id: _id,
        title: _id,
      });
      for (const p of _.range(0, 50)) {
        let fakeCheckPositionId = `${_id}${p}`;
        checkPositionItems.push({
          _id: fakeCheckPositionId,
          checkPositionId: _id,
          title: faker.lorem.words(2),
          details: faker.lorem.paragraph(),
          style: _.sample(['circle', 'triangle', 'square']),
          status: _.sample([0, 1, 2]),
        });
      }
    }
  }
  
  await fs.writeFile(path.resolve("../Crew\ Safety/Data/fake-check-positions.json"), JSON.stringify(checkPositions, null, 2))
  await fs.writeFile(path.resolve("../Crew\ Safety/Data/fake-check-position-items.json"), JSON.stringify(checkPositionItems, null, 2))
}
main();
