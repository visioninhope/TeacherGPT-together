import { Table } from "@mantine/core";

type GenericObject = { [key: string]: string };

const studentMock = {
  data: {
    allStudents: [
      {
        studentId: "1",
        firstName: "Monty",
        middleName: "Nathaniel",
        lastName: "Anthony",
        sex: "M",
        dob: "2010-03-18",
        email: "moanthony28@titanacademy.edu",
        ohioSsid: "WW4542553",
      },
      {
        studentId: "2",
        firstName: "Lacey",
        middleName: "Aubrey",
        lastName: "Baldwin",
        sex: "F",
        dob: "2009-11-09",
        email: "labaldwin28@titanacademy.edu",
        ohioSsid: "QE2954355",
      },
      {
        studentId: "3",
        firstName: "Hasan",
        middleName: "Jake",
        lastName: "Bell",
        sex: "M",
        dob: "2009-06-02",
        email: "habell28@titanacademy.edu",
        ohioSsid: "ZI6882339",
      },
      {
        studentId: "4",
        firstName: "Richard",
        middleName: "Joshua",
        lastName: "Bradshaw",
        sex: "M",
        dob: "2010-04-11",
        email: "ribradshaw28@titanacademy.edu",
        ohioSsid: "IS5669694",
      },
      {
        studentId: "5",
        firstName: "Aliya",
        middleName: "Amelia",
        lastName: "Castro",
        sex: "F",
        dob: "2010-01-27",
        email: "alcastro28@titanacademy.edu",
        ohioSsid: "QN7419694",
      },
    ] as GenericObject[],
  },
};

const headersMapping: { [key: string]: string } = {
//   studentId: "Student ID",
  firstName: "First Name",
  middleName: "Middle Name",
  lastName: "Last Name",
  sex: "Sex",
  dob: "Date of Birth",
  email: "Email",
  ohioSsid: "Ohio SSID",
};

export function StudentTable() {
  const students = studentMock.data.allStudents;

  const headers = Object.keys(headersMapping).map((key) => (
    <Table.Th key={key}>{headersMapping[key]}</Table.Th>
  ));

  // Generating table rows
  const rows = students.map((student, index) => (
    <Table.Tr key={index}>
      {Object.keys(headersMapping).map((key) => (
        <Table.Td key={`${key}-${index}`}>{student[key]}</Table.Td>
      ))}
    </Table.Tr>
  ));

  return (
    <Table>
      <Table.Thead>
        <Table.Tr>{headers}</Table.Tr>
      </Table.Thead>
      <Table.Tbody>{rows}</Table.Tbody>
    </Table>
  );
}
