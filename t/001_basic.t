#!perl -w
use strict;
use Test::More;
use Project::Libs;
use Sub::Inspector;
use C;
use Path::Class;

subtest 'exception' => sub {
    local $@;
    eval { Sub::Inspector->new(C->can('null')) };
    ok $@;
};

subtest 'file, line, name' => sub {
    {
        my $ins = Sub::Inspector->new(C->can('parent_method'));
        is $ins->file, file(__FILE__)->dir->subdir('lib')->file('ParentClass.pm')->absolute;
        is $ins->line, 5;
        is $ins->name, 'parent_method';
    }
};

subtest 'proto' => sub {
    {
        my $ins = Sub::Inspector->new(C->can('try'));
        is $ins->proto,     '&;@';
        is $ins->prototype, '&;@';
    }
    {
        my $ins = Sub::Inspector->new(C->can('plain'));
        is $ins->proto,     undef;
        is $ins->prototype, undef;
    }
};

subtest 'attr' => sub {
    {
        my $ins = Sub::Inspector->new(C->can('has_attr'));
        is_deeply [$ins->attrs],      [qw(lvalue)];
        is_deeply [$ins->attributes], [qw(lvalue)];
    }
    {
        my $ins = Sub::Inspector->new(C->can('has_multi_attrs'));
        is_deeply [$ins->attrs],      [qw(lvalue method)];
        is_deeply [$ins->attributes], [qw(lvalue method)];
    }
    {
        my $ins = Sub::Inspector->new(C->can('plain'));
        is_deeply [$ins->attrs],      [];
        is_deeply [$ins->attributes], [];
    }
};

done_testing;
