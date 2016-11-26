use utf8;
package Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::User

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<user>

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
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

=head2 access_delete

  data_type: 'integer'
  default_value: 1
  is_nullable: 0

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
  default_value: 'CURRENT_TIMESTAMP'
  is_nullable: 0

=head2 date_update

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: 'CURRENT_TIMESTAMP'
  is_nullable: 0

????????

=cut

__PACKAGE__->add_columns(
  "user_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "old_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "sex",
  { data_type => "integer", is_nullable => 1 },
  "access",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "access_delete",
  { data_type => "integer", default_value => 1, is_nullable => 0 },
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

=item * L</user_id>

=item * L</mail>

=back

=cut

__PACKAGE__->set_primary_key("user_id", "mail");

=head1 UNIQUE CONSTRAINTS

=head2 C<mail_UNIQUE>

=over 4

=item * L</mail>

=back

=cut

__PACKAGE__->add_unique_constraint("mail_UNIQUE", ["mail"]);

=head1 RELATIONS

=head2 managers

Type: has_many

Related object: L<Schema::Result::Manager>

=cut

__PACKAGE__->has_many(
  "managers",
  "Schema::Result::Manager",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 orders

Type: has_many

Related object: L<Schema::Result::Order>

=cut

__PACKAGE__->has_many(
  "orders",
  "Schema::Result::Order",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 products

Type: has_many

Related object: L<Schema::Result::Product>

=cut

__PACKAGE__->has_many(
  "products",
  "Schema::Result::Product",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 stat_user2source

Type: might_have

Related object: L<Schema::Result::StatUser2source>

=cut

__PACKAGE__->might_have(
  "stat_user2source",
  "Schema::Result::StatUser2source",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 supplier2managers

Type: has_many

Related object: L<Schema::Result::Supplier2manager>

=cut

__PACKAGE__->has_many(
  "supplier2managers",
  "Schema::Result::Supplier2manager",
  { "foreign.manager_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 suppliers

Type: has_many

Related object: L<Schema::Result::Supplier>

=cut

__PACKAGE__->has_many(
  "suppliers",
  "Schema::Result::Supplier",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user2admin

Type: might_have

Related object: L<Schema::Result::User2admin>

=cut

__PACKAGE__->might_have(
  "user2admin",
  "Schema::Result::User2admin",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user2phone

Type: might_have

Related object: L<Schema::Result::User2phone>

=cut

__PACKAGE__->might_have(
  "user2phone",
  "Schema::Result::User2phone",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user2sessions

Type: has_many

Related object: L<Schema::Result::User2session>

=cut

__PACKAGE__->has_many(
  "user2sessions",
  "Schema::Result::User2session",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-09-20 15:38:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Nyeb0wPd6jl1wlKPexUkDg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
