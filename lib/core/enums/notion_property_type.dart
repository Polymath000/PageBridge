enum NotionPropertyType {
  text('text'),
  number('number'),
  url('url'),
  richText('rich_text'),
  phoneNumber('phone_number'),
  email('email'),
  createdTime('created_time'),
  createdBy('created_by'),
  lastEditedTime('last_edited_time'),
  lastEditedBy('last_edited_by'),
  person('person'),
  rollup('rollup'),
  select('select'),
  status('status'),
  multiSelect('multi_select'),
  checkbox('checkbox'),
  date('date'),
  relation('relation'),
  title('title'),
  files('files'),
  formula('formula'),
  unknown('unknown');

  final String value;
  const NotionPropertyType(this.value);

  static NotionPropertyType fromString(String type) {
    return NotionPropertyType.values.firstWhere(
      (e) => e.value == type,
      orElse: () => NotionPropertyType.unknown,
    );
  }
}
