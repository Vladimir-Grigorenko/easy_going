use utf8;
package Schema::Result::Sale;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Sale

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<sale>

=cut

__PACKAGE__->table("sale");

=head1 ACCESSORS

=head2 sale_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 saletype_id

  data_type: 'integer'
  default_value: 1
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 value

  data_type: 'integer'
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_nullable: 1

=head2 date_start

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: 'CURRENT_TIMESTAMP'
  is_nullable: 0

=head2 date_end

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: 'CURRENT_TIMESTAMP'
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 description

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 1000

=head2 url

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 1000

=head2 url_md5

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=cut

__PACKAGE__->add_columns(
  "sale_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "saletype_id",
  {
    data_type => "integer",
    default_value => 1,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "value",
  { data_type => "integer", is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_nullable => 1 },
  "date_start",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
  },
  "date_end",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
  },
  "title",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "description",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 1000 },
  "url",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 1000 },
  "url_md5",
  { data_type => "varchar", is_nullable => 0, size => 45 },
);

=head1 PRIMARY KEY

=over 4

=item * L</sale_id>

=back

=cut

__PACKAGE__->set_primary_key("sale_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<index3>

=over 4

=item * L</url_md5>

=back

=cut

__PACKAGE__->add_unique_constraint("index3", ["url_md5"]);

=head1 RELATIONS

=head2 product2sales

Type: has_many

Related object: L<Schema::Result::Product2sale>

=cut

__PACKAGE__->has_many(
  "product2sales",
  "Schema::Result::Product2sale",
  { "foreign.sale_id" => "self.sale_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 saletype

Type: belongs_to

Related object: L<Schema::Result::SaleType>

=cut

__PACKAGE__->belongs_to(
  "saletype",
  "Schema::Result::SaleType",
  { saletype_id => "saletype_id" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-10-19 15:43:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:T2qQVArRRaIHsEve5pZZog


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
