class contents{
  final String heading;
  final String description;

  contents({required this.heading, required this.description});

  factory contents.fromMap(Map<String, dynamic> map) {
    return contents(
      heading: map['heading'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'heading' : heading,
      'description' : description
    };
  }
}