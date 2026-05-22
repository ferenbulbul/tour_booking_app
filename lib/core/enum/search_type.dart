// enum SearchType {
//   departure, // index = 0
//   destination, // index = 1
// }

// extension SearchTypeExtension on SearchType {
//   static SearchType fromIndex(int index) {
//     switch (index) {
//       case 0:
//         return SearchType.departure;
//       case 1:
//         return SearchType.destination;
//       default:
//         return SearchType.departure; // fallback
//     }
//   }

//   int get indexValue {
//     return index; // can also write this explicitly
//   }

//   String get label {
//     switch (this) {
//       case SearchType.departure:
//         return "Departure Point";
//       case SearchType.destination:
//         return "Tour Point";
//     }
//   }
// }
