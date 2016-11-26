use utf8;
package Schema::Result::Category2;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Category2

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<category2>

=cut

__PACKAGE__->table("category2");

=head1 ACCESSORS

=head2 category_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 parent_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 sort

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 overflow

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 is_catalog

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

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
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "sort",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "overflow",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "is_catalog",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
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


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-11-04 11:08:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:J+qWc/Kmrr3dyUP+pLu+6Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
