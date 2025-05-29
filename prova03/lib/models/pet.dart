class Pet {
  final int? id;
  final String name;
  final String breed;
  final int age;
  final String observations;
  final PetGenero genero;
  final bool gostaCriancas;
  final bool conviveOutrosAnimais;
  final bool adaptaApartamentos;
  final bool gostaPasseios;
  final bool tranquiloVisitas;
  final bool latePouco;
  final bool sociavelEstranhos;
  final bool compativelCriancasPequenas;
  final bool gostaCarrosViagens;
  final bool disponivelParaAdocao;
  final String? imageUrl;

  Pet({
    this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.observations,
    required this.genero,
    required this.gostaCriancas,
    required this.conviveOutrosAnimais,
    required this.adaptaApartamentos,
    required this.gostaPasseios,
    required this.tranquiloVisitas,
    required this.latePouco,
    required this.sociavelEstranhos,
    required this.compativelCriancasPequenas,
    required this.gostaCarrosViagens,
    required this.disponivelParaAdocao,
    this.imageUrl,
  });

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'],
      name: map['name'],
      breed: map['breed'],
      age: map['age'],
      observations: map['observations'],
      genero: map['genero'] == 'macho' ? PetGenero.macho : PetGenero.femea,
      gostaCriancas: map['gostaCriancas'] == 1,
      conviveOutrosAnimais: map['conviveOutrosAnimais'] == 1,
      adaptaApartamentos: map['adaptaApartamentos'] == 1,
      gostaPasseios: map['gostaPasseios'] == 1,
      tranquiloVisitas: map['tranquiloVisitas'] == 1,
      latePouco: map['latePouco'] == 1,
      sociavelEstranhos: map['sociavelEstranhos'] == 1,
      compativelCriancasPequenas: map['compativelCriancasPequenas'] == 1,
      gostaCarrosViagens: map['gostaCarrosViagens'] == 1,
      disponivelParaAdocao: map['disponivelParaAdocao'] == 1,
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'age': age,
      'observations': observations,
      'genero': genero == PetGenero.macho ? 'macho' : 'femea',
      'gostaCriancas': gostaCriancas ? 1 : 0,
      'conviveOutrosAnimais': conviveOutrosAnimais ? 1 : 0,
      'adaptaApartamentos': adaptaApartamentos ? 1 : 0,
      'gostaPasseios': gostaPasseios ? 1 : 0,
      'tranquiloVisitas': tranquiloVisitas ? 1 : 0,
      'latePouco': latePouco ? 1 : 0,
      'sociavelEstranhos': sociavelEstranhos ? 1 : 0,
      'compativelCriancasPequenas': compativelCriancasPequenas ? 1 : 0,
      'gostaCarrosViagens': gostaCarrosViagens ? 1 : 0,
      'disponivelParaAdocao': disponivelParaAdocao ? 1 : 0,
      'imageUrl': imageUrl,
    };
  }
}

enum PetGenero { macho, femea }
