use utf8;
package Schema::Result::VUserInfo;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::VUserInfo - VIEW

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<v_user_info>

=cut

__PACKAGE__->table("v_user_info");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 old_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 sex

  data_type: 'integer'
  is_nullable: 1

0 - male
1 - femail

=head2 access

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

0 -  ?????? ??????
1 - ?????? ??????
2 - ?????? ????????????

=head2 mail

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 first_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

???

=head2 last_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

???????

=head2 patronymic

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 fio

  data_type: 'varchar'
  is_nullable: 0
  size: 500

?? ??????? ?????

=head2 address

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 500

????? ????????


=head2 date_create

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 date_update

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

????????

=head2 access_delete

  data_type: 'integer'
  default_value: 1
  is_nullable: 0

=head2 access_id

  data_type: 'integer'
  default_value: 1
  extra: {unsigned => 1}
  is_nullable: 1

0 - ?? ???????
1 - ???????
2 - ????????????

=head2 user_admin_group_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 manager_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "user_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "old_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "sex",
  { data_type => "integer", is_nullable => 1 },
  "access",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "mail",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "first_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "last_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "patronymic",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "fio",
  { data_type => "varchar", is_nullable => 0, size => 500 },
  "address",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 500 },
  "date_create",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "date_update",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "access_delete",
  { data_type => "integer", default_value => 1, is_nullable => 0 },
  "access_id",
  {
    data_type => "integer",
    default_value => 1,
    extra => { unsigned => 1 },
    is_nullable => 1,
  },
  "user_admin_group_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "manager_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 1,
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-08-17 13:54:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1MYRL750XPMuxR3fEmc2kw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
