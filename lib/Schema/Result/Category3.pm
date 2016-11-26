use utf8;
package Schema::Result::Category3;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Category3

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<category3>

=cut

__PACKAGE__->table("category3");

=head1 ACCESSORS

=head2 category_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 parent_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 sort

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 overflow

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

0 - hidden
1 - visible

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 500

=head2 url

  data_type: 'varchar'
  is_nullable: 0
  size: 500

=head2 url2site

  data_type: 'varchar'
  is_nullable: 0
  size: 1000

=head2 instr

  data_type: 'text'
  is_nullable: 0

=head2 date_create

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: 'CURRENT_TIMESTAMP'
  is_nullable: 0

=head2 date_update

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: 'CURRENT_TIMESTAMP'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "category_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "parent_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "sort",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "overflow",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 500 },
  "url",
  { data_type => "varchar", is_nullable => 0, size => 500 },
  "url2site",
  { data_type => "varchar", is_nullable => 0, size => 1000 },
  "instr",
  { data_type => "text", is_nullable => 0 },
  "date_create",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
  },
  "date_update",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</category_id>

=back

=cut

__PACKAGE__->set_primary_key("category_id");

=head1 RELATIONS

=head2 category2feature_group

Type: might_have

Related object: L<Schema::Result::Category2featureGroup>

=cut

__PACKAGE__->might_have(
  "category2feature_group",
  "Schema::Result::Category2featureGroup",
  { "foreign.category_id" => "self.category_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 product2categories

Type: has_many

Related object: L<Schema::Result::Product2category>

=cut

__PACKAGE__->has_many(
  "product2categories",
  "Schema::Result::Product2category",
  { "foreign.category_id" => "self.category_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-11-06 12:21:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jtDXViHI14ZbhfDMnSGAPg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
